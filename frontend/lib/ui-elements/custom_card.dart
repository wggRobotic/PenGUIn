import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget{
  final String title;
  final String value;
  final Widget? data;
  final bool alignAtTop;

  const CustomCard({
    super.key,
    required this.title,
    this.value = "",
    this.data,
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
              data == null
                ? Expanded(
                  child: Text(
                    value,
                    softWrap: true,
                  ),
                )
              : data!,
            ],
          ),
        ),
      )
    );
  }
}