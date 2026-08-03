import 'package:flutter/material.dart';

// Store the nodes and handle them
class NodeProvider extends ChangeNotifier {
  List<String> nodes = ["test1", "test2", "test3", "test4", "..."];

  void updateNodeList(List<String> newNodes) {
    nodes = newNodes;
    notifyListeners();
  }

  void selectNode (int position) {
    // TODO
  }
}
