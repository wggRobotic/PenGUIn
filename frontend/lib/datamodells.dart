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
  String function;
  bool centered;

  SliderDatamodell({
    required this.label,
    required this.function,
    required this.centered
  });
}

class JoystickDatamodell {
  String xFunction;
  String yFunction;

  JoystickDatamodell({
    required this.xFunction,
    required this.yFunction
  });
}

class CameraDatamodell {
  String name;
  bool selected;

  CameraDatamodell({
    required this.name,
    this.selected = false
  });
}
