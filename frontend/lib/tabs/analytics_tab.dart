import 'package:flutter/material.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/information_right_sheet.dart';

class AnalyticsTab extends StatelessWidget{
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    List<AnalyticsDatamodell> items = [
      AnalyticsDatamodell(type: "service", name: "name", category: "category", isAvailable: true),
      AnalyticsDatamodell(type: "topic", name: "name", description: "description"),
      AnalyticsDatamodell(type: "action", name: "name", description: "description"),
    ];

    // Display a list containing a set of topics, services, etc. and arrange it like a column
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return ListTile(
              leading: items[index].isAvailable
                ? Icon(Icons.offline_pin_outlined)
                : Icon(Icons.error_outline),
              title: Text(items[index].name),
              subtitle: Text(items[index].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 24.0,
                children: [
                  items[index].category != null
                  ? Row( // Display the category
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4.0,
                      children: [
                        Icon(Icons.sell_outlined),
                        Text(
                          items[index].category!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
                  SizedBox( // Display the type of communication
                    width: 80.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4.0,
                      children: [
                        Icon(Icons.type_specimen_outlined),
                        Text(
                          items[index].type,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              tileColor: theme.surfaceContainer,
              selectedTileColor: theme.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(left: 12.0, bottom: 4.0, top: 4.0, right: 8.0),
              onTap: () {
                // TODO: Open overlay and display some data
                InformationRightSheet.openInformationRightSheet(context, items[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Apply filter",
        child: Icon(Icons.filter_list_outlined),
        onPressed: () {
          // TOOD: Implement Filters
        }
      ),
    );
  }
}