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
    // Apply and remove all redundant spaces
    subscribing = newSubsribingList.replaceAll(" ", "");
    publishing = newPublishingList.replaceAll(" ", "");
    service = newServiceList.replaceAll(" ", "");
    notifyListeners();
  }
}

class TopicInformationProvider extends ChangeNotifier {
  String interface = "-";
  String publisher = "-";
  String subscriber = "-";

  void setInterface(String newInterface) {
    // Apply and remove all redundant spaces
    interface = newInterface.replaceAll(" ", "");
    notifyListeners();
  }
  
  void setPublishers(String newPublishers) {
    // Apply and remove all redundant spaces
    publisher = newPublishers.replaceAll(" ", "");
    notifyListeners();
  }

  void setSubscribers(String newSubscriber) {
    // Apply and remove all redundant spaces
    subscriber = newSubscriber.replaceAll(" ", "");
    notifyListeners();
  }
}

class ServiceInformationProvider extends ChangeNotifier {
  String provider = "-";
  String interface = "-";

  void setProvider(String newProvider) {
    // Apply and remove all redundant spaces
    provider = newProvider.replaceAll(" ", "");
    notifyListeners();
  }

  void setInterface(String newInterface) {
    // Apply and remove all redundant spaces
    interface = newInterface.replaceAll(" ", "");
    notifyListeners();
  }
}

class ActionInformationProvider extends ChangeNotifier {
  String interface = "-";

  void setInterface(String newInterface) {
    // Apply and remove all redundant spaces
    interface = newInterface.replaceAll(" ", "");
    notifyListeners();
  }
}

class AnalyticsProvider extends ChangeNotifier {
  List<AnalyticsDatamodell> data = [];

  void updateAnalyticsData(List<AnalyticsDatamodell> newData) {
    data = newData;
    notifyListeners();
  }
}
