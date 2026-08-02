import 'package:flutter/material.dart';

class NodesTab extends StatelessWidget{
  const NodesTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> placeholder = ["test1", "test2", "test3", "test4", "..."];
    final theme = Theme.of(context).colorScheme;

    // Display a simple list of available nodes
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: placeholder.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(placeholder[index]),
            tileColor: theme.surfaceContainer,
            leading: IconButton(
              icon: Icon(Icons.play_circle_outlined),
              onPressed: () {},
            ),
            selectedTileColor: theme.secondaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            contentPadding: EdgeInsets.all(4.0),
            selected: true,
          );
        },
      ),
    );
  }
}

// TODO: Implement selection
// TODO: Launch a node
//        => Provider handling selection state
//        => Datamodell defining a node (make sur eit matches the JSON)