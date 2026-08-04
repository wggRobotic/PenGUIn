import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/error_snackbar.dart';
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
  // Node data
  // -------------------------------------------------------------------------------------------------------------------------------
  // Start a node by publishing to a certain topic
  void startSingleNode(BuildContext context, String executableName, String packageName, int id) {
    // Make sure to connect with the server
    if (!isConnected) {
      connect(context);
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

  void stopNode(BuildContext context, int id) {
    // Make sure to connect with the server
    if (!isConnected) {
      connect(context);
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
}
