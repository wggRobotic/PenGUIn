class NodeDatamodell {
  String name;
  String description;
  String documentationLink;
  bool isSelected;
  bool isRunning;

  NodeDatamodell({
    required this.name,
    this.description = "",
    this.documentationLink = "",
    this.isSelected = false,
    this.isRunning = false,
  });
}
