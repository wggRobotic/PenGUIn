import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';

// Store the nodes and handle them
class NodeProvider extends ChangeNotifier {
  List<NodeDatamodell> nodes = [];
  bool get nodeIsSelected => nodes.any((n) => n.isSelected);
  String subscribing = "-";
  String publishing = "-";
  String service = "-";

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

  void setNodeInformation(String newSubsribingList, String newPublishingList, String newServiceList) {
    subscribing = newSubsribingList;
    publishing = newPublishingList;
    service = newServiceList;
    notifyListeners();
  }
}

class TopicInformationProvider extends ChangeNotifier {
  String interface = "-";
  String publisher = "-";
  String subscriber = "-";

  void setInterface(String newInterface) {
    interface = newInterface;
    notifyListeners();
  }
  
  void setPublishers(String newPublishers) {
    publisher = newPublishers;
    notifyListeners();
  }

  void setSubscribers(String newSubscriber) {
    subscriber = newSubscriber;
    notifyListeners();
  }
}

class ServiceAndActionInformationProvider extends ChangeNotifier {
  String provider = "-";
  String interface = "-";

  void setProvider(String newProvider) {
    provider = newProvider;
    notifyListeners();
  }

  void setInterface(String newInterface) {
    interface = newInterface;
    notifyListeners();
  }
}
