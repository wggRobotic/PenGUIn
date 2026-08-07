import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/information_box/node_information_box.dart';
import 'package:frontend/ui-elements/information_box/service_and_action_information_box.dart';
import 'package:frontend/ui-elements/information_box/topic_information_box.dart';

class InformationRightSheet {
  // Open the RightSheet and display some data
  static void openInformationRightSheet(BuildContext context, dynamic item, bool isNode) {
    final theme = Theme.of(context).colorScheme;

    // Display specific information depending on the item
    Widget content = Placeholder();
    if (isNode) {
      // Display Node content
      content = NodeInformationBox(node: item);
    } else {
      final typeToLowerCase = item.type.toLowerCase();

      // Pick the correct analytics content
      if (typeToLowerCase == "topic") {
        content = TopicInformationBox(topic: item);
      } else if (typeToLowerCase == "service" || typeToLowerCase == "action") {
        content = ServiceInformationBox(type: item);
      }
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
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                appBar: AppBar(
                  title: isNode
                    ? Text("Information (Node: ${item.executableName})")
                    : Text("Information (Type: ${item.type})"),
                  backgroundColor: theme.primaryContainer,
                ),
                body: SingleChildScrollView(child: content)
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
