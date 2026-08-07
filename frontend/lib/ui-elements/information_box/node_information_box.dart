import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/custom_card.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NodeInformationBox extends StatefulWidget{
  final NodeDatamodell node;

  const NodeInformationBox({
    super.key,
    required this.node,
  });

  @override
  State<NodeInformationBox> createState() => _NodeInformationBoxState();
}

class _NodeInformationBoxState extends State<NodeInformationBox> {
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    // Request the desired data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isRunning = widget.node.isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard( // Display the description from the config file
              title: "Description:",
              value: widget.node.description
            ),
            widget.node.documentationLink.isEmpty // Display a link to the official documentation
              ? SizedBox.shrink()
              : CustomCard(
                title: "Documentation:",
                alignAtTop: false,
                data: TextButton(
                  child: Text(widget.node.documentationLink),
                  onPressed: () async {
                    // Open the link
                    final url = Uri.parse(widget.node.documentationLink);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Could not launch $url"));
                    }
                  }
                ),
              ),
            CustomCard(
              title: "",
              data: Column(
                spacing: 4.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      Text("Package:"),
                      Text(widget.node.packageName)
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      Text("Executable:"),
                      Text(widget.node.executableName)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton.extended(
              icon: isRunning
                ? Icon(Icons.pause_circle_outlined)
                : Icon(Icons.play_circle_outlined),
              label: isRunning
                ? Text("Stop")
                : Text("Run"),
              tooltip: isRunning
                ? "Stop"
                : "Run",
              onPressed: () {
                // Get the position of the node within the list
                final nodeList = context.read<NodeProvider>().nodes;
                int position = nodeList.indexWhere((n) => n.executableName == widget.node.executableName && n.packageName == widget.node.packageName);

                // Start/Stop the node
                if(isRunning) {
                  RosbridgeConnector().stopNode(context, position);
                  setState(() {
                    isRunning = false;
                  });
                } else {
                  RosbridgeConnector().startSingleNode(context, widget.node.executableName, widget.node.packageName, position);
                  setState(() {
                    isRunning = true;
                  });
                }
              },
            ),
          ),
        ),
      ]
    );
  }
}

// TODO: Display data about a specfic node:
//          - description (subscribing, publishing, services);
//          - parameters -> Get values -> Set values -> Check them (Via configuration)
