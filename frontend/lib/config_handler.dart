import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/error_snackbar.dart';
import 'package:path/path.dart' as path;

class NodesConfigHandler {

  // Get the path of the whole config file
  String getRelativeConfigPath() {
    final exePath = File(Platform.resolvedExecutable).absolute.path;
    final baseDirectory = path.dirname(exePath);

    return path.join(baseDirectory, "config", "nodes_config.json");
  }

  // Ensure the config exists
  Future<void> ensureConfigExists(String configPath) async {
    final file = File(configPath);

    // Move on if the config exists
    if (await file.exists()) return;

    // Copy the config from the assets
    const assetPath = 'assets/config/nodes_config.json';
    final defaultJson = await rootBundle.loadString(assetPath);

    await file.parent.create(recursive: true);
    await file.writeAsString(defaultJson, flush: true);
  }

  // Read the config
  Future<List<NodeDatamodell>> applyNodeConfiguration(context) async {
    final configPath = getRelativeConfigPath();

    // Make sure it exists
    await ensureConfigExists(configPath);

    // Get the JSON config
    String jsonConfig = await File(configPath).readAsString();

    // Parse it to the datamodell and return it
    try {
      Map<String, dynamic> decodedConfig = jsonDecode(jsonConfig) as Map<String, dynamic>;
      List<dynamic> nodesList = (decodedConfig['nodes'] as List<dynamic>? ?? []);
      return nodesList.map((e) {
        final map = e as Map<String, dynamic>;

        return NodeDatamodell(
          executableName: (map['executableName'] as String?) ?? 'No name provided',
          packageName: (map['packageName'] as String?) ?? '',
          description: (map['description'] as String?) ?? '',
          documentationLink: (map['documentationLink'] as String?) ?? '',
          isSelected: (map['isSelected'] == "true") ? true : false,
        );
      }).toList();
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: e.toString().trim()));
      return [NodeDatamodell(executableName: "", packageName: "")];
    }
  }
}
