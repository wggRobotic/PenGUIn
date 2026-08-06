import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RosbridgeConnector {
  late WebSocketChannel channel;
  bool isConnected = false;

  // -------------------------------------------------------------------------------------------------------------------------------
  // Connection
  // -------------------------------------------------------------------------------------------------------------------------------
  // Connect to the WebSocket server
  Future<void> connect(BuildContext context) async {
    try {
      channel = WebSocketChannel.connect(Uri.parse("ws://localhost:9090"));
      await channel.ready;
      isConnected = true;
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
      return;
    }
  }

  // Disconnect from the WebSocket server
  void disconnect() {
    channel.sink.close();
    isConnected = false;
  }

  // -------------------------------------------------------------------------------------------------------------------------------
  // PenGUIn Control Node: Control nodes
  // -------------------------------------------------------------------------------------------------------------------------------
  // Start a node by publishing to a certain topic
  void startSingleNode(BuildContext context, String executableName, String packageName, int id) async {
    // Make sure to connect with the server
    if (!isConnected) {
      await connect(context);
    }

    // Publish the launch command
    //final cmd = "ros2 run $packageName $executableName";
    final cmd = "ros2 run controller_package wheel_controller";
    final json = {
      "op": "publish",
      "topic": "penGUIn/start_single",
      "type": "interface_package/msg/Single",
      "msg": {
        "cmd": cmd,
        "id": id
      },
    };
    channel.sink.add(jsonEncode(json));
  }

  void stopNode(BuildContext context, int id) async {
    // Make sure to connect with the server
    if (!isConnected) {
      await connect(context);
    }

    // Publish the cancel command
    final json = {
      "op": "publish",
      "topic": "penGUIn/stop_single",
      "type": "std_msgs/msg/Int32",
      "msg": {"data": id}
    };
    channel.sink.add(jsonEncode(json));
  }

  // -------------------------------------------------------------------------------------------------------------------------------
  // RosAPI: Introspect nodes, topics, etc.
  // -------------------------------------------------------------------------------------------------------------------------------
  void getTopicPublishers(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      await connect(context);
    }

    // Call the server
    channel.sink.add(getServiceCall("publishers", {"topic": topicName}, "getTopicPublishers"));

    // Identify the response within the stream
    await for (final response in channel.stream) {
      final data = jsonDecode(response as String);
      if (data["op"] == "service_response" && data["id"] == "getTopicPublishers" && data["result"]) {
        // Format the result
        final publishersList = (data["values"]["publishers"] as List).cast<String>();
        final String formattedPublishers;
        if (publishersList.isEmpty) {
          formattedPublishers = "-";
        } else {
          formattedPublishers = publishersList.map((e) => e).join('\n');
        }

        // Apply the data
        context.read<TopicInformationProvider>().setPublishers(formattedPublishers);
        break;
      }
    }
  }
  void getTopicSubscribers(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      await connect(context);
    }

    // Call the server
    channel.sink.add(getServiceCall("subscribers", {"topic": topicName}, "getTopicSubscribers"));

    // Identify the response within the stream
    await for (final response in channel.stream) {
      final data = jsonDecode(response as String);

      if (data["op"] == "service_response" && data["id"] == "getTopicSubscribers" && data["result"]) {
        // Format the result
        final subscribersList = (data["values"]["subscribers"] as List).cast<String>();
        final String formattedSubscribers;
        if (subscribersList.isEmpty) {
          formattedSubscribers = "-";
        } else {
          formattedSubscribers = subscribersList.map((e) => e).join('\n');
        }

        // Apply the data
        context.read<TopicInformationProvider>().setSubscribers(formattedSubscribers);
        break;
      }
    }
  }
  void getTopicInterface(BuildContext context, String topicName) async {
    String interface = "-";
    String definition = "-";
    
    // Make sure the connection works
    if (!isConnected) {
      await connect(context);
    }

    // Identify the interface name
    channel.sink.add(getServiceCall("topic_type", {"topic": topicName},"getTopicInterface_1"));
    await for (final response in channel.stream) {
      final data = jsonDecode(response as String);

      if (data["op"] == "service_response" && data["id"] == "getTopicInterface_1" && data["result"]) {
        final type = data["values"]["type"] as String;
        if (!type.isEmpty) {
          interface = type;
        }
        break;
      }
    }

    // Get the interface definition
    if (!interface.isEmpty && interface != "-") {
      channel.sink.add(getServiceCall("message_details", {"type": interface}, "getTopicInterface_2"));

      await for (final response in channel.stream) {
        final data = jsonDecode(response as String);

        if (data["op"] == "service_response" && data["id"] == "getTopicInterface_1" && data["result"]) {
          print(data);
        }
      }
    }
  }


  String getServiceCall (String serviceName, Map<String, dynamic> args, String id) {
    return jsonEncode({
      "op": "call_service",
      "service": "/rosapi/$serviceName",
      "args": args,
      "id": id
    });
  }
}

// TODO: Start advertising
// TODO: Show error messages if something fails
