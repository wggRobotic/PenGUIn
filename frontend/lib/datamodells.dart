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
