import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/information_box/action_information_box.dart';
import 'package:frontend/ui-elements/information_box/service_information_box.dart';
import 'package:frontend/ui-elements/information_box/topic_information_box.dart';

class InformationRightSheet {
  // Open the RightSheet and display some data
  static void openInformationRightSheet(BuildContext context, AnalyticsDatamodell item) {
    final theme = Theme.of(context).colorScheme;

    // Display specific information depending on the communication type
    Widget content = Placeholder();
    final typeToLowerCase = item.type.toLowerCase();
    if (typeToLowerCase == "topic") {
      content = TopicInformationBox(topic: item);
    } else if (typeToLowerCase == "service") {
      content = ServiceInformationBox(service: item);
    } else if (typeToLowerCase == "action") {
      content = ActionInformationBox(action: item);
    }

    // Open the overlay and display the correct information
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Information",
      barrierColor: theme.scrim.withAlpha(64),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 8,
            color: theme.surface,
            child: SizedBox(
              width: 500,
              height: double.infinity,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Information (Type: ${item.type})"),
                  backgroundColor: theme.primaryContainer,
                ),
                body: content
              ),
            )
          )
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0), // Start at the right side
          end: Offset.zero,          // End: normal position
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
