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
  List<AnalyticsDatamodell> allData = [];
  List<String> typeFilter = [];
  List<String> categoryFilter = [];

  void updateAnalyticsData(List<AnalyticsDatamodell> newData) {
    data = newData;
    allData = newData;
    notifyListeners();
  }

  void updateFilterAttributes() {
    // Get all types
    typeFilter = data.map((e) => e.type.toLowerCase()).where((t) => t.isNotEmpty).toSet().toList();
    categoryFilter = data.map((e) => e.category.toLowerCase()).where((t) => t.isNotEmpty).toSet().toList();
    categoryFilter.removeWhere((e) => e == " - ");
  }

  void applyFilter(List<dynamic> selectedTypes, List<String> selectedCategories) {
    // Include all data
    data = allData;

    // Standardise the values to be lowercase
    final types = selectedTypes.map((s) => s.toLowerCase()).toSet();
    final categories = selectedCategories.map((s) => s.toLowerCase()).toSet();

    // Check witch filter were applied
    final noTypeFilter = types.isEmpty;
    final noCategoryFilter = categories.isEmpty;

    // Apply the filter
    data = allData.where((e) {
      final typeMatches = noTypeFilter || types.contains(e.type.toLowerCase());
      final categoryMatches = noCategoryFilter || categories.contains(e.category.toLowerCase());
      return typeMatches && categoryMatches;
    }).toList();

    notifyListeners();
  }

  void resetFilter() {
    data = allData;
    notifyListeners();
  }
}

class ControlsProvider extends ChangeNotifier {
  JoystickDatamodell joystick = JoystickDatamodell(function: "");
  List<SliderDatamodell> horizontalSliders = [];
  List<SliderDatamodell> verticalSliders = [];
  List<CameraDatamodell> cameras = [];
  int selectedPosition = 0;

  void updateJoystick (JoystickDatamodell newJoystick) {
    joystick = newJoystick;
    notifyListeners();
  }

  void updateHorizontalSliders (List<SliderDatamodell> sliders) {
    horizontalSliders = sliders;
    notifyListeners();
  }

  void updateVerticalSliders (List<SliderDatamodell> sliders) {
    verticalSliders = sliders;
    notifyListeners();
  }

  void updateCamera (List<CameraDatamodell> newCameras) {
    // Apply the configuration
    cameras = newCameras;

    // By default select the first one
    selectedPosition = 0;
    cameras[selectedPosition].selected = true;
    notifyListeners();
  }

  void selectCamera (int position, bool selectionState) {
    // Don't deselect the selected one
    if(selectedPosition == position) return;

    // Unselect the previous one
    cameras[selectedPosition].selected = false;

    // Select the new one
    cameras[position].selected = selectionState;

    // Remember the position of the selection
    selectedPosition = position;
    notifyListeners();
  }
}

class LogProvider extends ChangeNotifier {
  List<LogEntryDatamodell> logEntries = [];
  List<LogEntryDatamodell> allLogEntries = [];
  List<int> logLevelFilter = [];
  List<String> fileNameFilter = [];

  void addLogEntry(LogEntryDatamodell newLogEntry) {
    //logEntries.add(newLogEntry);
    logEntries.insert(0, newLogEntry);
    allLogEntries.insert(0, newLogEntry);
    notifyListeners();
  }

  void clearLog() {
    logEntries.clear();
    notifyListeners();
  }

  void updateFilterAttributes() {
    // Get all types
    logLevelFilter = allLogEntries.map((e) => e.logLevel).toSet().toList();
    fileNameFilter = allLogEntries.map((e) => e.fileName.toLowerCase()).where((t) => t.isNotEmpty).toSet().toList();
  }

  void applyFilter(List<dynamic> selectedLogLevels, List<String> selectedFileNames) {
    // Include all log entries
    logEntries = allLogEntries;

    // Standardise the values to be lowercase
    final fileNames = selectedFileNames.map((s) => s.toLowerCase()).toSet();

    // Check which filter were applied
    final noLogLevelFilter = selectedLogLevels.isEmpty;
    final noFileNameFilter = fileNames.isEmpty;

    // Apply the filter
    logEntries = allLogEntries.where((e) {
      final logLevelMatches = noLogLevelFilter || selectedLogLevels.contains(e.logLevel);
      final fileNameMatches = noFileNameFilter || fileNames.contains(e.fileName.toLowerCase());
      return logLevelMatches && fileNameMatches;
    }).toList();

    notifyListeners();
  }

  void resetFilter() {
    logEntries = allLogEntries;
    notifyListeners();
  }
}
