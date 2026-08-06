import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/custom_card.dart';

class ServiceInformationBox extends StatelessWidget{

  const ServiceInformationBox({super.key});

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
          title: "Provider:",
          value: "TODO"
        ),
        CustomCard(
          title: "Schema:",
          value: "TODO"
        ),
      ],
    );
  }
}
