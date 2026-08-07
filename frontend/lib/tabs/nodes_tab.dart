import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/information_right_sheet.dart';
import 'package:provider/provider.dart';

class NodesTab extends StatefulWidget{
  const NodesTab({super.key});

  @override
  State<NodesTab> createState() => _NodesTabState();
}

class _NodesTabState extends State<NodesTab> {
  final RosbridgeConnector connector = RosbridgeConnector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final nodes = context.watch<NodeProvider>().nodes;
    final nodeIsSelected = context.watch<NodeProvider>().nodeIsSelected;

    // Display a simple list of available nodes
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: nodes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(nodes[index].executableName),
              subtitle: Text(nodes[index].description),
              tileColor: theme.surfaceContainer,
              leading: IconButton(
                icon: nodes[index].isRunning
                  ? Icon(Icons.pause_circle_outlined)
                  : Icon(Icons.play_circle_outlined),
                tooltip: nodes[index].isRunning
                  ? "Stop"
                  : "Run",
                onPressed: () {
                  // Run or stop a node
                  if (nodes[index].isRunning) {
                    context.read<NodeProvider>().runNode(index, false);
                    connector.stopNode(context, index);
                  } else {
                    context.read<NodeProvider>().runNode(index, true);
                    connector.startSingleNode(context, nodes[index].executableName, nodes[index].packageName, nodes[index].customCMD, index);
                  }
                },
              ),
              selectedTileColor: theme.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.all(4.0),
              selected: nodes[index].isSelected,
              onTap: () {
                // Simplify (un-)selection
                if (nodes[index].isSelected) {
                  context.read<NodeProvider>().selectNode(index, false);
                } else if (nodeIsSelected) {
                  context.read<NodeProvider>().selectNode(index, true);
                }

                // Open an information overlay
                InformationRightSheet.openInformationRightSheet(context, nodes[index], true);
              },
              onLongPress: () {
                if (nodes[index].isSelected) {
                  context.read<NodeProvider>().selectNode(index, false);
                } else {
                  context.read<NodeProvider>().selectNode(index, true);
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: nodeIsSelected
        ? FloatingActionButton(
            tooltip: "Run",
            onPressed: () {
              int nodesCount = nodes.length;
              for (var i = 0; i < nodesCount; i++) {
                NodeDatamodell node = nodes[i];
                if (node.isSelected) {
                  context.read<NodeProvider>().runNode(i, true);
                  connector.startSingleNode(context, node.executableName, node.packageName, node.customCMD, i);
                  context.read<NodeProvider>().selectNode(i, false);
                }
              }
              for (var node in nodes) {
                if (node.isSelected) {
                  context.read();
                }
              }
            },
            child: Icon(Icons.play_circle_outlined),
          )
        : null,
    );
  }

  @override
  void dispose() {
    // Disconnect from the WebSocket server
    connector.disconnect();
    super.dispose();
  }
}
