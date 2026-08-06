import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/custom_card.dart';

class ActionInformationBox extends StatelessWidget{

  const ActionInformationBox({super.key});

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
        CustomCard(
          title: "Feedback:",
          value: "TODO: Check out"
        ),
      ],
    );
  }
}
