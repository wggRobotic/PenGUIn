import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:provider/provider.dart';

class LogTab extends StatelessWidget{
  const LogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    List<LogEntryDatamodell> logEntries = context.watch<LogProvider>().logEntries;

    // Display a list of log entries
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: ListView.separated(
          itemCount: logEntries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final logEntry = logEntries[index];
            return ListTile(
              // Coloured leading icon indicating the log level
              leading: logEntry.logLevel == 10
                ? Icon(
                    Icons.bug_report_outlined,
                    color: Color(0xFF5DADE2),
                    semanticLabel: "Debug",
                  )
                : logEntry.logLevel == 20
                  ? Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF52BE80),
                      semanticLabel: "Info",
                    )
                  : logEntry.logLevel == 30
                    ? Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF4D03F),
                        semanticLabel: "Warning",
                      )
                    : logEntry.logLevel == 40
                      ? Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFE74C3C),
                          semanticLabel: "Error",
                        )
                      : logEntry.logLevel == 50
                        ? Icon(
                            Icons.cancel_outlined,
                            color: Color(0xFF641E16),
                            semanticLabel: "Fatal",
                          )
                        : Icon(
                            Icons.help_outline_rounded,
                            semanticLabel: "Unknown",
                          ),
              title: Text(logEntry.fullLogMessage),
              subtitle: Text("File name: ${logEntry.fileName}"),
              trailing: Text("Line: ${logEntry.lineWithinTheCode}"),
              tileColor: theme.surfaceContainer,
              selectedTileColor: theme.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              contentPadding: EdgeInsets.only(left: 12.0, bottom: 4.0, top: 4.0, right: 8.0),
            );
          },
        ),
      ),
    );
  }
}

// TODO: Add a filter dialog
// TODO: Filter for
//        - The file name
//        - The log level
