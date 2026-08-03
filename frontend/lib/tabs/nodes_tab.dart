import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:provider/provider.dart';

class NodesTab extends StatelessWidget{
  const NodesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final nodes = context.watch<NodeProvider>().nodes;

    // Display a simple list of available nodes
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: nodes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(nodes[index].name),
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
                } else {
                  context.read<NodeProvider>().runNode(index, true);
                }
              },
            ),
            selectedTileColor: theme.secondaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            contentPadding: EdgeInsets.all(4.0),
            selected: nodes[index].isSelected,
            onTap: () {
              if (nodes[index].isSelected) {
                context.read<NodeProvider>().selectNode(index, false);
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
    );
  }
}

// TODO: Implement selection
// TODO: Launch a node
//        => Connect to the server