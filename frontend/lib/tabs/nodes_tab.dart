import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/rosbridge_connector.dart';
import 'package:provider/provider.dart';

class NodesTab extends StatelessWidget{
  const NodesTab({super.key});

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
                    RosbridgeConnector().stopNode(context, index);
                  } else {
                    context.read<NodeProvider>().runNode(index, true);
                    RosbridgeConnector().startSingleNode(context, nodes[index].executableName, nodes[index].packageName, index);
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
              // TODO: Run all selected nodes and skip already running ones
            },
            child: Icon(Icons.play_circle_outlined),
          )
        : null,
    );
  }
}

// TODO: Launch a node
//        => Connect to the server