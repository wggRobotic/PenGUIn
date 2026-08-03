import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

// Store the nodes and handle them
class NodeProvider extends ChangeNotifier {
  List<NodeDatamodell> nodes = [
    NodeDatamodell(name: "name"),
    NodeDatamodell(name: "name"),
    NodeDatamodell(name: "name")
  ];

  void updateNodeList(List<NodeDatamodell> newNodes) {
    nodes = newNodes;
    notifyListeners();
  }

  void selectNode (int position) {
    // TODO
  }
}
