import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

// Store the nodes and handle them
class NodeProvider extends ChangeNotifier {
  List<NodeDatamodell> nodes = [];

  void updateNodeList(List<NodeDatamodell> newNodes) {
    nodes = newNodes;
    notifyListeners();
  }

  void selectNode(int position, bool selectionState) {
    nodes[position].isSelected = selectionState;
    notifyListeners();
  }

  void runNode(int position, bool runState) {
    nodes[position].isRunning = runState;
    notifyListeners();
  }
}
