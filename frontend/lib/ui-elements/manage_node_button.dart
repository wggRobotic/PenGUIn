import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:provider/provider.dart';

class ManageNodeButton extends StatefulWidget{
  final NodeDatamodell item;

  const ManageNodeButton({
    super.key,
    required this.item,
  });

  @override
  State<ManageNodeButton> createState() => _ManageNodeButtonState();
}

class _ManageNodeButtonState extends State<ManageNodeButton> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: isRunning
        ? Icon(Icons.pause_circle_outlined)
        : Icon(Icons.play_circle_outlined),
      label: isRunning
        ? Text("Stop")
        : Text("Run"),
      tooltip: isRunning
        ? "Stop"
        : "Run",
      onPressed: () {
        RosbridgeConnector connector = RosbridgeConnector();

        // Get the position of the node within the list
        final nodeList = context.read<NodeProvider>().nodes;
        int position = nodeList.indexWhere((n) => n.executableName == widget.item.executableName && n.packageName == widget.item.packageName);

        // Start/Stop the node
        if(isRunning) {
          connector.stopNode(context, position);
          setState(() {
            isRunning = false;
          });
        } else {
          connector.startSingleNode(context, widget.item.executableName, widget.item.packageName, widget.item.customCMD, position);
          setState(() {
            isRunning = true;
          });
        }
      },
    );
  }
}