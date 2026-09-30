class NodeDatamodell {
  String executableName;
  String packageName;
  String nodeName;
  String description;
  String documentationLink;
  String customCMD;
  bool isSelected;
  bool isRunning;

  NodeDatamodell({
    required this.executableName,
    required this.packageName,
    this.nodeName = "",
    this.description = "",
    this.documentationLink = "",
    this.customCMD = "",
    this.isSelected = false,
    this.isRunning = false,
  });
}

class AnalyticsDatamodell{
  String type;
  String name;
  String description;
  String category;
  bool isAvailable;

  AnalyticsDatamodell({
    required this.type,
    required this.name,
    this.description =  "",
    this.category = "",
    this.isAvailable = false,
  });
}

class SliderDatamodell {
  String label;
  InterfaceRequestDatamodell function;
  bool centered;

  SliderDatamodell({
    required this.label,
    required this.function,
    required this.centered
  });
}

class JoystickDatamodell {
  InterfaceRequestDatamodell function;

  JoystickDatamodell({
    required this.function,
  });
}

class CameraDatamodell {
  String label;
  bool selected;

  CameraDatamodell({
    required this.label,
    this.selected = false
  });
}

class LogEntryDatamodell {
  int logLevel;
  String fileName;
  String fullLogMessage;
  int lineWithinTheCode;

  LogEntryDatamodell({
    required this.logLevel,
    required this.fileName,
    required this.fullLogMessage,
    required this.lineWithinTheCode
  });
}

class InterfaceRequestDatamodell {
  String tag;
  String type;
  String topic;

  InterfaceRequestDatamodell({
    required this.tag,
    required this.type,
    required this.topic
  });
}