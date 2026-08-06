import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/custom_card.dart';
import 'package:provider/provider.dart';

class TopicInformationBox extends StatefulWidget{
  final AnalyticsDatamodell topic;

  const TopicInformationBox({
    super.key,
    required this.topic
  });

  @override
  State<TopicInformationBox> createState() => _TopicInformationBoxState();
}

class _TopicInformationBoxState extends State<TopicInformationBox> {
  final RosbridgeConnector connector = RosbridgeConnector();

  @override
  void initState() {
    super.initState();
    // Request the desired data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      connector.getTopicInterface(context, "rosout");
      connector.getTopicPublishers(context, "rosout");
      connector.getTopicSubscribers(context, "rosout");
    });
  }

  @override
  Widget build(BuildContext context) {
    final interface = context.watch<TopicInformationProvider>().interface;
    final publisher = context.watch<TopicInformationProvider>().publisher;
    final subscriber = context.watch<TopicInformationProvider>().subscriber;

    // Display the data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          title: "Description:",
          value: widget.topic.description
        ),
        CustomCard(
          title: "Implementation:",
          data: Column(
            spacing: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text("Publisher:"),
                  Text(publisher)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text("Subscriber:"),
                  Text(subscriber)
                ],
              ),
            ],
          ),
        ),
        CustomCard(
          title: "Interface:",
          value: interface
        ),
      ],
    );
  }
}
