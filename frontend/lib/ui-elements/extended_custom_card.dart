import 'package:flutter/material.dart';

class ExtendedCustomCard extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String value1;
  final String value2;
  final bool alignAtTop;

  const ExtendedCustomCard({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.value1,
    required this.value2,
    this.alignAtTop = true
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Card(
      color: theme.surfaceContainerHigh,
      surfaceTintColor: theme.primary,
      margin: EdgeInsets.only(left: 8.0, top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 468,
          child: Row(
            spacing: 8.0,
            crossAxisAlignment: alignAtTop
             ? CrossAxisAlignment.start
             : CrossAxisAlignment.center,
            children: [
              Text(title),
              Column(
                spacing: 4.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      Text(subtitle1),
                      SizedBox(
                        width: 312,
                        child: Text(
                          value1,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      Text(subtitle2),
                      SizedBox(
                        width: 312,
                        child: Text(
                          value2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

// TODO: Make sure aech Text() colapses as expected
