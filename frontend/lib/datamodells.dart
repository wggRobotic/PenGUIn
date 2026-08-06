class NodeDatamodell {
  String executableName;
  String packageName;
  String description;
  String documentationLink;
  bool isSelected;
  bool isRunning;

  NodeDatamodell({
    required this.executableName,
    required this.packageName,
    this.description = "",
    this.documentationLink = "",
    this.isSelected = false,
    this.isRunning = false,
  });
}

class AnalyticsDatamodell{
  String type;
  String name;
  String interface;
  String description;
  String? category;
  bool isAvailable;

  AnalyticsDatamodell({
    required this.type,
    required this.name,
    required this.interface,
    this.description =  "",
    this.category,
    this.isAvailable = false,
  });
}
