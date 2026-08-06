import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RosbridgeConnector {
  late WebSocketChannel channel;
  bool isConnected = false;
  bool connecting = false;
  bool listening = false;
  final Map<String, Completer<Map<String, dynamic>>> pending = {};

  // -------------------------------------------------------------------------------------------------------------------------------
  // PenGUIn Control Node: Control nodes
  // -------------------------------------------------------------------------------------------------------------------------------
  // Start a node by publishing to a certain topic
  void startSingleNode(BuildContext context, String executableName, String packageName, int id) async {
    // Make sure to connect with the server
    if (!isConnected) {
      await connectAndListen(context);
    }

    // Publish the launch command
    final cmd = "ros2 run $packageName $executableName";
    //final cmd = "ros2 run controller_package wheel_controller";
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
      await connectAndListen(context);
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
      await connectAndListen(context);
    }

    // Call the server
    final data = await callServiceAndWait( context, "publishers", {"topic": topicName},"getTopicPublishers");

    // Parse the response
    final publishersList = (data["values"]["publishers"] as List).cast<String>();
    final formattedPublishers = publishersList.isEmpty ? "-" : publishersList.join('\n');

    // Apply the values
    context.read<TopicInformationProvider>().setPublishers(formattedPublishers);
  }
  void getTopicSubscribers(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      await connectAndListen(context);
    }

    // Call the server
    final data = await callServiceAndWait(context, "subscribers", {"topic": topicName}, "getTopicSubscribers");

    // Parse the response
    final subscribersList = (data["values"]["subscribers"] as List).cast<String>();
    final formattedSubscribers = subscribersList.isEmpty ? "-" : subscribersList.join('\n');

    // Apply the data
    context.read<TopicInformationProvider>().setSubscribers(formattedSubscribers);
  }
  Future<void> getTopicInterface(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      await connectAndListen(context);
    }

    // Get the topic interface
    final r1 = await callServiceAndWait(context, "topic_type", {"topic": topicName}, "getTopicInterface_1");

    final interface = (r1["values"]["type"] as String?)?.trim();
    if (interface == null || interface.isEmpty) {
      context.read<TopicInformationProvider>().setSubscribers("-");
      return;
    }

    // Get the interface definition
    final r2 = await callServiceAndWait(context, "message_details", {"type": interface}, "getTopicInterface_2");
    final typedefs = (r2["values"]?["typedefs"] as List?) ?? const [];

    // Convert the definition into a String
    if (typedefs.isNotEmpty) {
      final t0 = typedefs.first;

      final fieldnames = (t0["fieldnames"] as List?) ?? const [];
      final fieldtypes = (t0["fieldtypes"] as List?) ?? const [];

      final lines = <String>[];
      for (int i = 0; i < fieldnames.length; i++) {
        final name = fieldnames[i]?.toString() ?? "";
        final type = (i < fieldtypes.length ? fieldtypes[i] : null)?.toString() ?? "";
        lines.add("$type $name");
      }

      // Assemble the final String and apply it
      final definition = lines.join("\n");
      context.read<TopicInformationProvider>().setInterface("$interface \n-------\n$definition");
    } else {
      context.read<TopicInformationProvider>().setInterface(interface);
    }
  }

  // -------------------------------------------------------------------------------------------------------------------------------
  // Helper functions
  // -------------------------------------------------------------------------------------------------------------------------------
  // Wait for the response after calling a service
  Future<Map<String, dynamic>> callServiceAndWait(BuildContext context, String service, Map<String, dynamic> args, String id, {Duration timeout = const Duration(seconds: 5)}) async {
    final completer = Completer<Map<String, dynamic>>();
    pending[id] = completer;

    channel.sink.add(jsonEncode({"op": "call_service", "service": "/rosapi/$service", "args": args, "id": id}));

    return completer.future.timeout(timeout, onTimeout: () {
      pending.remove(id);
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "No rosbridge response for id=$id"));
      return {};
    });
  }
  // Connect to the WebSocket server
  Future<void> connectAndListen(BuildContext context) async {
    // Return if this is already done and running
    if (isConnected && listening) {
      return;
    }
    if (connecting) {
      return;
    }

    // Mark as connecting
    connecting = true;

    try {
      // Open a Websocket channel
      channel = WebSocketChannel.connect(Uri.parse("ws://localhost:9090"));
      await channel.ready;

      // Mark as connected
      isConnected = true;

      // Make sure to listen to the data stream
      if (!listening) {
        listening = true;

        // Listen to incoming data
        channel.stream.listen((message) {
          final data = jsonDecode(message as String) as Map<String, dynamic>;

          // Identify responses and handle them
          if(data["op"] == "service_response") {
            final id = data["id"]?.toString();
            if (id != null && pending.containsKey(id)) {
              pending[id]!.complete(data);
              pending.remove(id);
            }
          }
        }, onError: (e) {
          // Handle the error
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
          for (final c in pending.values) {
            c.completeError(e);
          }
          pending.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
      isConnected = false;
      listening = false;
      return;
    } finally {
      connecting = false;
    }
  }
  // Disconnect from the WebSocket server
  void disconnect() {
    channel.sink.close();
    isConnected = false;
  }

}

// TODO: Start advertising
