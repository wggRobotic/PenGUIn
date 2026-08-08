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
  void startSingleNode(BuildContext context, String executableName, String packageName, String cmd, int id) async {
    // Make sure to connect with the server
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the given names aren't empty
    if (executableName.isEmpty || packageName.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Empty package and node name"));
      return;
    }

    // Pick the correct command - by default `ros2 run <pkg> <exe>`
    if (cmd.isEmpty) {
      cmd = "ros2 run $packageName $executableName";
    }

    // Publish the launch command
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

    // Uppdate the UI
    if (!context.mounted) return;
    context.read<NodeProvider>().runNode(id, true);
  }
  void stopNode(BuildContext context, int id) async {
    // Make sure to connect with the server
    if (!isConnected) {
      if (!context.mounted) return;
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

    // Update the UI
    if (!context.mounted) return;
    context.read<NodeProvider>().runNode(id, false);
  }

  // -------------------------------------------------------------------------------------------------------------------------------
  // RosAPI: Introspect nodes, topics, etc.
  // -------------------------------------------------------------------------------------------------------------------------------
  void getNodeInformation(BuildContext context, String nodeName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Call the server and receive the information
    if (!context.mounted) return;
    final data = await callServiceAndWait(context, "node_details", {"node": nodeName}, "getNodeInformation");
    if (!context.mounted) return;
    if (!checkServerResponse(context, data)) return;

    final subscribingList = (data["values"]["subscribing"] as List).cast<String>();
    final publishingList = (data["values"]["publishing"] as List).cast<String>();
    final serviceList = (data["values"]["services"] as List).cast<String>();

    // Convert to clear strings
    final formattedSubscribingList = subscribingList.isEmpty ? "-" : subscribingList.join("\n");
    final formattedPublishingList = publishingList.isEmpty ? "-" : publishingList.join("\n");
    final formattedServiceList = serviceList.isEmpty ? "-" : serviceList.join("\n");
    // Apply the data to the UI
    if (!context.mounted) return;
    context.read<NodeProvider>().setNodeInformation(formattedSubscribingList, formattedPublishingList, formattedServiceList);
  }
  void getTopicPublishers(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    topicName = validateNameFormat(topicName);

    // Call the server
    if (!context.mounted) return;
    final data = await callServiceAndWait( context, "publishers", {"topic": topicName},"getTopicPublishers");
    if (!context.mounted) return;
    if (!checkServerResponse(context, data)) return;

    // Parse the response
    final publishersList = (data["values"]["publishers"] as List).cast<String>();
    final formattedPublishers = publishersList.isEmpty ? "-" : publishersList.join("\n");

    // Apply the values
    if (!context.mounted) return;
    context.read<TopicInformationProvider>().setPublishers(formattedPublishers);
  }
  void getTopicSubscribers(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    topicName = validateNameFormat(topicName);

    // Call the server
    if (!context.mounted) return;
    final data = await callServiceAndWait(context, "subscribers", {"topic": topicName}, "getTopicSubscribers");
    if (!context.mounted) return;
    if (!checkServerResponse(context, data)) return;

    // Parse the response
    final subscribersList = (data["values"]["subscribers"] as List).cast<String>();
    final formattedSubscribers = subscribersList.isEmpty ? "-" : subscribersList.join("\n");

    // Apply the data
    if (!context.mounted) return;
    context.read<TopicInformationProvider>().setSubscribers(formattedSubscribers);
  }
  void getTopicInterface(BuildContext context, String topicName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    topicName = validateNameFormat(topicName);

    // Get the topic interface
    if (!context.mounted) return;
    final r1 = await callServiceAndWait(context, "topic_type", {"topic": topicName}, "getTopicInterface_1");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r1)) return;

    final interface = (r1["values"]["type"] as String?)?.trim();
    if (interface == null || interface.isEmpty) {
      if (!context.mounted) return;
      context.read<TopicInformationProvider>().setInterface("-");
      return;
    }

    // Get the interface definition
    if (!context.mounted) return;
    final r2 = await callServiceAndWait(context, "message_details", {"type": interface}, "getTopicInterface_2");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r2)) {
      context.read<TopicInformationProvider>().setInterface(interface);
      return;
    }
    final definition = buildRos2InterfaceFromMap(r2);
    
    // Assemble the final String and apply it
    if (!context.mounted) return;
    context.read<TopicInformationProvider>().setInterface("$interface \n------------\n$definition");
  }
  void getServiceProviders(BuildContext context, String serviceName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    serviceName = validateNameFormat(serviceName);

    // Call the server
    if (!context.mounted) return;
    final data = await callServiceAndWait(context, "service_providers", {"service": serviceName}, "getServiceProviders");
    if (!context.mounted) return;
    if (!checkServerResponse(context, data)) {
      return;
    }

    // Parse the response
    final providerList = (data["values"]["providers"] as List).cast<String>();
    final formattedProviders = providerList.isEmpty ? "-" : providerList.join("\n");

    // Apply the data
    if (!context.mounted) return;
    context.read<ServiceInformationProvider>().setProvider(formattedProviders);
  }
  void getServiceInterface(BuildContext context, String serviceName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    serviceName = validateNameFormat(serviceName);

    // Call the server and get the interface
    if (!context.mounted) return;
    final r1 = await callServiceAndWait(context, "service_type", {"service": serviceName}, "getServiceInterface_1");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r1)) return;
    final interface = (r1["values"]["type"] as String?)?.trim();
    if (interface == null || interface.isEmpty) {
      if (!context.mounted) return;
      context.read<ServiceInformationProvider>().setInterface("-");
      return;
    }

    // Call the server and get request details
    if (!context.mounted) return;
    final r2 = await callServiceAndWait(context, "service_request_details", {"type": interface}, "getServiceInterface_2");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r2)) {
      context.read<ServiceInformationProvider>().setInterface(interface);
      return;
    }
    final request = buildRos2InterfaceFromMap(r2);

    // Call the server and get response details
    if (!context.mounted) return;
    final r3 = await callServiceAndWait(context, "service_response_details", {"type": interface}, "getServiceInterface_3");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r3)) {
      context.read<ServiceInformationProvider>().setInterface("$interface\n------------\n$request");
      return;
    }
    final response = buildRos2InterfaceFromMap(r3);

    // Apply the definition
    if (!context.mounted) return;
    context.read<ServiceInformationProvider>().setInterface("$interface\n------------\n$request\n---\n$response");
  }
  void getActionInterface(BuildContext context, String actionName) async {
    // Make sure the connection works
    if (!isConnected) {
      if (!context.mounted) return;
      await connectAndListen(context);
    }

    // Make sure the name starts with "/"
    actionName = validateNameFormat(actionName);

    // Get the interface
    if (!context.mounted) return;
    final r1 = await callServiceAndWait(context, "action_type", {"action": actionName}, "getActionInterface_1");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r1)) return;
    final interface = (r1["values"]["type"] as String?)?.trim();
    if (interface == null || interface.isEmpty) {
      if (!context.mounted) return;
      context.read<ActionInformationProvider>().setInterface("-");
      return;
    }

    // Call the server and get the goal details
    if (!context.mounted) return;
    final r2 = await callServiceAndWait(context, "action_goal_details", {"type": interface}, "getActionInterface_2");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r2)) {
      context.read<ActionInformationProvider>().setInterface(interface);
      return;
    }
    final goal = buildRos2InterfaceFromMap(r2);

    // Call the server and get the feedback details
    if (!context.mounted) return;
    final r3 = await callServiceAndWait(context, "action_feedback_details", {"type": interface}, "getActionInterface_3");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r3)) {
      context.read<ActionInformationProvider>().setInterface("$interface\n------------\n$goal");
      return;
    }
    final feedback = buildRos2InterfaceFromMap(r3);

    // Call the server and get the result details
    if (!context.mounted) return;
    final r4 = await callServiceAndWait(context, "action_result_details", {"type": interface}, "getActionInterface_4");
    if (!context.mounted) return;
    if (!checkServerResponse(context, r4)) {
      context.read<ActionInformationProvider>().setInterface("$interface\n------------\n$goal\n---\n$feedback");
      return;
    }
    final result = buildRos2InterfaceFromMap(r4);

    if (!context.mounted) return;
    context.read<ActionInformationProvider>().setInterface("$interface\n------------\n$goal\n---\n$feedback\n---\n$result");
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
      if (!context.mounted) return {};
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
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
          for (final c in pending.values) {
            c.completeError(e);
          }
          pending.clear();
        });
      }
    } catch (e) {
      if (!context.mounted) return;
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
    try {
      channel.sink.close();
      isConnected = false;
    } catch (e) {
      return;
    }
  }
  // Make sure each name starts with a "/"
  String validateNameFormat(String name) {
    if (name.startsWith("/", 0)) {
      return name;
    } else {
      return "/$name";
    }
  }

  String buildRos2InterfaceFromMap(Map<String, dynamic> root) {
    final lines = <String>[];
    final values = root['values'];
    final valuesMap = (values is Map<String, dynamic>) ? values : null;

    final typedefs = (valuesMap?['typedefs'] is List) ? valuesMap!['typedefs'] as List : const [];

    // Return if there're no typedefs
    if (typedefs.isEmpty) {
      return "-";
    }

    // Handle each typedef of the typedefs
    for (final td in typedefs) {
      if (td is! Map<String, dynamic>) {
        // If typedefs is no Map
        continue;
      }

      final fieldnamesRaw = td['fieldnames'];
      final fieldtypesRaw = td['fieldtypes'];
      final fieldarraylenRaw = td['fieldarraylen'];

      final fieldnames = (fieldnamesRaw is List) ? fieldnamesRaw : const <dynamic>[];
      final fieldtypes = (fieldtypesRaw is List) ? fieldtypesRaw : const <dynamic>[];
      final fieldarraylen = (fieldarraylenRaw is List) ? fieldarraylenRaw : const <dynamic>[];

      final n = fieldnames.length;

      for (int i = 0; i < n; i++) {
        final name = fieldnames[i]?.toString() ?? '';

        final baseType = (i < fieldtypes.length) ? (fieldtypes[i]?.toString() ?? '') : '';

        // Handle arrays
        String suffix = '';
        if (i < fieldarraylen.length) {
          final lenVal = fieldarraylen[i];

          if (lenVal is! num) {
            suffix = ""; // It's part of the datatype
          } else if (lenVal == 0) {
            suffix = "[]"; // Unbounded
          } else if (lenVal < 0) {
            suffix = ""; // No Array
          } else {
            suffix = '[$lenVal]'; // fixed length
          }
        }

        // Add a line to the list: <type> <name>
        if (baseType.isNotEmpty && name.isNotEmpty) {
          lines.add("$baseType$suffix $name");
        } else if (baseType.isNotEmpty) {
          lines.add("$baseType$suffix");
        } else if (name.isNotEmpty) {
          lines.add("$suffix $name");
        }
      }
    }

    // Remove the last line
    while (lines.isNotEmpty && lines.last.trim().isEmpty) {
      lines.removeLast();
    }

    // Retrun the list as one single String
    return lines.join('\n');
  }

  bool checkServerResponse(BuildContext context, Map<String, dynamic> response) {
    // Show an error for an empty response
    if (response.isEmpty) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Empty response by the server"));
      return false;
    }

    // Handle an error returned by the server
    if (response["result"] == false || response["result"] == "false" || response["result"] == 0) {
      final values = response["values"];
      String errorMessage = "-";

      // Get the full error message
      if (values is String) {
        errorMessage = values.trim();
      } else if (values is List) {
        errorMessage = values.join(", ").trim();
      }

      // Display the error message
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: errorMessage));
      return false;
    }
    // Everything else should be valid
    return true;
  }
}

// TODO: Handle wrong configuration
// TODO: When receiving information return if the node isn't running or the topic/service/action isn't available
// TODO: Identify whether a node is running or not
// TODO: Identify whether a topic/service/action is available or not