import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:path/path.dart' as path;

class NodesConfigHandler {

  // Get the path of the whole config file
  String getRelativeConfigPath(String fileName) {
    final exePath = File(Platform.resolvedExecutable).absolute.path;
    final baseDirectory = path.dirname(exePath);

    return path.join(baseDirectory, "config", fileName);
  }

  // Ensure the config exists
  Future<void> ensureConfigExists(String configPath, String assetName) async {
    final file = File(configPath);

    // Move on if the config exists
    if (await file.exists()) return;

    // Copy the config from the assets
    final String assetPath = "assets/config/$assetName";
    final defaultJson = await rootBundle.loadString(assetPath);

    await file.parent.create(recursive: true);
    await file.writeAsString(defaultJson, flush: true);
  }

  // Read the node config
  Future<List<NodeDatamodell>> applyNodeConfiguration(BuildContext context) async {
    final configPath = getRelativeConfigPath("nodes_config.json");

    // Make sure it exists
    await ensureConfigExists(configPath, "nodes_config.json");

    // Get the JSON config
    String jsonConfig = await File(configPath).readAsString();

    // Parse it to the datamodell and return it
    try {
      List<dynamic> decodedConfig = jsonDecode(jsonConfig);
      return decodedConfig.map((e) {
        final map = e as Map<String, dynamic>;

        return NodeDatamodell(
          executableName: (map["executableName"] as String?) ?? "-",
          packageName: (map["packageName"] as String?) ?? "-",
          nodeName: (map["nodeName"] as String?) ?? "-",
          description: (map["description"] as String?) ?? "-",
          documentationLink: (map['documentationLink'] as String?) ?? "",
          customCMD: (map["customCMD"] as String?) ?? "",
          isSelected: (map["isSelected"] == true) ? true : false,
        );
      }).toList();
    } catch (e) {
      // Show an error message
      if (!context.mounted) return [NodeDatamodell(executableName: "-", packageName: "-")];
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Unable to load the node configuration: ${e.toString().trim()}"));
      return [NodeDatamodell(executableName: "-", packageName: "-")];
    }
  }

  // Read the analytics config
  Future<List<AnalyticsDatamodell>> applyAnalyticsConfiguration(BuildContext context) async {
    final configPath = getRelativeConfigPath("analytics_config.json");

    // Make sure it exists
    await ensureConfigExists(configPath, "analytics_config.json");

    // Get the JSON config
    String jsonConfig = await File(configPath).readAsString();

    // Parse it to the datamodell and return it
    try {
      final List<dynamic> decodedConfig = jsonDecode(jsonConfig);
      return decodedConfig.map((e) {
        final map = e as Map<String, dynamic>;

        return AnalyticsDatamodell(
          type: (map["type"] as String?) ?? "-",
          name: (map["name"] as String?) ?? "-",
          description: (map["description"] as String?) ?? "-",
          category: (map["category"] as String?) ?? "",
        );
      }).toList();
    } catch (e) {
      // Show an error message
      if (!context.mounted) return [AnalyticsDatamodell(type: "-", name: "-")];
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Unable to load the analytics configuration: ${e.toString().trim()}"));
      return [AnalyticsDatamodell(type: "-", name: "-")];
    }
  }
}

// TODO: Try to filter for wrong config data
