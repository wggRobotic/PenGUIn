import 'package:flutter/material.dart';

class ErrorSnackbar{
  const ErrorSnackbar();

  SnackBar buildErrorSnackBar({
    required BuildContext context,
    required String error,
  }) {
    final theme = Theme.of(context);

    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: (context.mounted)
        ? theme.colorScheme.errorContainer
        : Color(0xff250700),
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      dismissDirection: DismissDirection.horizontal,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "An error occurred",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: (context.mounted)
                ? theme.colorScheme.surface
                : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: (context.mounted)
                ? theme.colorScheme.surface
                : Colors.grey.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}
