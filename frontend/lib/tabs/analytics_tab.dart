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
            final item = items[index];
            return ListTile(
              leading: item.isAvailable
                ? Icon(Icons.sync_rounded)
                : Icon(Icons.sync_disabled_outlined),
              title: Text(item.name),
              subtitle: Text(item.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 24.0,
                children: [
                  item.category != null
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
                        Icon(Icons.lan_outlined),
                        Text(
                          item.type,
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
                // Open overlay and display further information
                InformationRightSheet.openInformationRightSheet(context, items[index], false);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Apply filter",
        child: Icon(Icons.filter_list_outlined),
        onPressed: () {
          // TODO: Implement Filters
        }
      ),
    );
  }
}
