import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/slider_box.dart';

class ControlsTab extends StatelessWidget{
  const ControlsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    final List<SliderDatamodell> sliders = [
      SliderDatamodell(label: "label", topic: "topic"),
      SliderDatamodell(label: "label", topic: "topic"),
    ];
    // TODO: implement build
    return Padding(
      padding: EdgeInsetsGeometry.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Placeholder(),
              Column( // Display as mutch sliders as configured
                spacing: 4.0,
                children: sliders.map((slider) {
                  return SliderBox(slider: slider, onChangeEnd: (value) {
                    // TODO: Implement the slider
                  });
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              Joystick( // Display a joystick for the steering
                base: JoystickBase(
                  decoration: JoystickBaseDecoration(
                    color: theme.surfaceContainer,
                    drawOuterCircle: false,
                  ),
                  arrowsDecoration: JoystickArrowsDecoration(
                    color: theme.primary,
                    enableAnimation: false
                  ),
                  size: 175,
                ),
                stick: JoystickStick(
                  decoration: JoystickStickDecoration(color: theme.primary),
                  size: 50,
                ),
                listener: (input) {
                  // TODO: Implement the Joystick
                }
              ),
              Expanded(child: SizedBox.shrink()),
              TextButton( // Button for the accerleration
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(theme.surfaceContainerHigh),
                  fixedSize: WidgetStatePropertyAll(Size(100, 125)),
                ),
                onPressed: () {
                  // TODO: Implement the button
                },
                child: Text("Speed")
              ),
              SizedBox(width: 8.0),
              TextButton( // Button for slowing down
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(theme.surfaceContainerHigh),
                  fixedSize: WidgetStatePropertyAll(Size(100, 125)),
                ),
                onPressed: () {
                  // TODO: Implement the button
                },
                child: Text("Brake")
              ),
            ],
          )
        ],
      )
    );
  }
}

// TODO: Get the sliders from the configuration
// TODO: Publish the input to the configured topics
