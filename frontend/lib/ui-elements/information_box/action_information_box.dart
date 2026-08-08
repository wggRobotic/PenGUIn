import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/custom_card.dart';
import 'package:provider/provider.dart';

class ActionInformationBox extends StatefulWidget{
  final AnalyticsDatamodell type;

  const ActionInformationBox({
    super.key,
    required this.type,
  });

  @override
  State<ActionInformationBox> createState() => _ActionInformationBoxState();
}

class _ActionInformationBoxState extends State<ActionInformationBox> {
  final RosbridgeConnector connector = RosbridgeConnector();

  @override
  void initState() {
    super.initState();
    // Request the desired data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get action information
      connector.getActionInterface(context, widget.type.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final interface = context.watch<ActionInformationProvider>().interface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          title: "Description:",
          value: widget.type.description,
        ),
        CustomCard(
          title: "Interface:",
          value: interface
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Disconnect this client
    connector.disconnect();
    super.dispose();
  }
}
