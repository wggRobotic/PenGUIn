import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/custom_card.dart';
import 'package:provider/provider.dart';

class ServiceInformationBox extends StatefulWidget{
  final AnalyticsDatamodell service;

  const ServiceInformationBox({
    super.key,
    required this.service,
  });

  @override
  State<ServiceInformationBox> createState() => _ServiceInformationBoxState();
}

class _ServiceInformationBoxState extends State<ServiceInformationBox> {
  final RosbridgeConnector connector = RosbridgeConnector();

  @override
  void initState() {
    super.initState();
    // Request the desired data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connector.getServiceInterface(context, widget.service.name);
      connector.getServiceProviders(context, widget.service.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceAndActionInformationProvider>().provider;
    final interface = context.watch<ServiceAndActionInformationProvider>().interface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          title: "Description:",
          value: widget.service.description,
        ),
        CustomCard(
          title: "Provider:",
          value: provider
        ),
        CustomCard(
          title: "Interface:",
          value: interface
        ),
      ],
    );
  }
}
