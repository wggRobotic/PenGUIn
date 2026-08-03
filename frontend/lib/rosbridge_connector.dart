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
      isConnected = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
      rethrow;
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
  // Auf einem Topic publishen
  void startSingleNode(BuildContext context, String executableName, String packageName) {
    if (!isConnected) {
      connect(context);
    }

    final cmd = "ros2 run $packageName $executableName";

    final json = {
      "op": "publish",
      "topic": "penGUIn/start_single",
      "type": "std_msgs/msg/String",
      "msg": {
        "data": cmd
      },
    };

    channel.sink.add(jsonEncode(json));
  }
}
