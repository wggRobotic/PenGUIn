import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/custom_card.dart';

class TopicInformationBox extends StatelessWidget{

  const TopicInformationBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          title: "Description:",
          value: "TODO"
        ),
        CustomCard(
          title: "Schema:",
          value: "TODO"
        ),
        CustomCard(
          title: "Implementation:",
          data: Column(
            spacing: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Publisher:"),
              Text("Subscriber:"),
            ],
          ),
        ),
      ],
    );
  }
}
