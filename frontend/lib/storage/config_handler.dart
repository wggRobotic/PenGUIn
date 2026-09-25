import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

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
          category: (map["category"] as String?) ?? " - ",
        );
      }).toList();
    } catch (e) {
      // Show an error message
      if (!context.mounted) return [AnalyticsDatamodell(type: "-", name: "-")];
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Unable to load the analytics configuration: ${e.toString().trim()}"));
      return [AnalyticsDatamodell(type: "-", name: "-")];
    }
  }

  // Read the steering config
  Future<void> applySteeringConfiguration(BuildContext context) async {
    final configPath = getRelativeConfigPath("steering_config.json");

    // Make sure it exists
    await ensureConfigExists(configPath, "steering_config.json");

    // Get the JSON config
    String jsonConfig = await File(configPath).readAsString();

    // Parse it to the datamodell and return it
    try {
      final Map<String, dynamic> decodedConfig = jsonDecode(jsonConfig);

      // Get the joystick configuration
      final JoystickDatamodell joystickConfiguration;
      if (decodedConfig["joystick"] != null) {
        final Map<String, dynamic> joystick = decodedConfig["joystick"];
        joystickConfiguration = JoystickDatamodell(
          xFunction: joystick["xFunction"] as String? ?? "",
          yFunction: joystick["yFunction"] as String? ?? ""
        );
      } else {
        joystickConfiguration = JoystickDatamodell(xFunction: "", yFunction: "");
      }
      if(!context.mounted) return;
      context.read<ControlsProvider>().updateJoystick(joystickConfiguration);

      // Get the horizontal sliders
      final List<SliderDatamodell> horizontalSliders = decodedConfig["horizontalSliders"] == null
        ? <SliderDatamodell>[]
        : getSliderDatamodellList(decodedConfig["horizontalSliders"] as List<dynamic>);
      if (!context.mounted) return;
      context.read<ControlsProvider>().updateHorizontalSliders(horizontalSliders);

      // Get the vertical sliders
      final List<SliderDatamodell> verticalSliders = decodedConfig["verticalSliders"] == null
        ? <SliderDatamodell>[]
        : getSliderDatamodellList(decodedConfig["verticalSliders"] as List<dynamic>);
      if (!context.mounted) return;
      context.read<ControlsProvider>().updateVerticalSliders(verticalSliders);

      // Get the cameras
      final List<CameraDatamodell> cameras = decodedConfig["cameras"] == null
        ? <CameraDatamodell>[]
        : (decodedConfig["cameras"] as List<dynamic>).map((c) {
          final camera = c as Map<String, dynamic>;
          return CameraDatamodell(
            label: camera["label"] as String? ?? "",
            function: camera["function"] as String? ?? ""
          );
        }).toList();
      if(!context.mounted) return;
      context.read<ControlsProvider>().updateCamera(cameras);
    } catch (e) {
      // Show an error message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Unable to load the steering configuration: ${e.toString().trim()}"));
      return;
    }
  }

  // Take the list from the JSON of the sliders and convert it to a list of the SliderDatamodell
  List<SliderDatamodell> getSliderDatamodellList(List<dynamic> sliders) {
    return sliders.map((s) {
      final slider = s as Map<String, dynamic>;

      return SliderDatamodell(
        label: slider["label"] as String? ?? "",
        function: slider["function"] as String? ?? "",
        centered: slider["centered"] as bool? ?? false,
      );
    }).toList();
  }
}
