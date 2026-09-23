import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/ui-elements/slider_box.dart';
import 'package:provider/provider.dart';

class ControlsTab extends StatelessWidget{
  const ControlsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    final List<SliderDatamodell> horizontalSliders = context.watch<SteeringProvider>().horizontalSliders;
    final List<SliderDatamodell> verticalSliders = context.watch<SteeringProvider>().verticalSliders;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Placeholder()),
              Container(
                color: theme.surfaceContainer,
                height: (MediaQuery.of(context).size.height * 3) / 5,
                width: (MediaQuery.of(context).size.width) / 5,
                child: ListView.separated( // Display vertical sliders
                  shrinkWrap: true,
                  itemCount: horizontalSliders.length,
                  itemBuilder: (context, index) {
                    return SliderBox(
                      slider: horizontalSliders[index],
                      verticalOrientation: false,
                      onChangeEnd: (value) {
                        // TODO: Implement the slider
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 4.0),
                ),
              ),
            ],
          ),
          Container(
            color: theme.surfaceContainer,
            child: Row(
              children: [
                Joystick( // Display a joystick
                includeInitialAnimation: false,
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
                SizedBox(
                  height: 225,
                  width: MediaQuery.of(context).size.width - 200,
                  child: ListView.separated( // Display as mutch vertical sliders as configured
                    itemCount: verticalSliders.length,
                    scrollDirection: Axis.horizontal, // TODO: Improve the scroll behavior
                    reverse: true,
                    itemBuilder: (context, index) {
                      return SliderBox(
                        slider: verticalSliders[index],
                        verticalOrientation: true,
                        onChangeEnd: (value) {
                          // TODO: Implement the slider
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 4.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Get the sliders centering setting from the configuration file
// TODO: Get the camera views from the configuration
// TODO: Define the relevant functions for steering
// TODO: Make the used functions configurable
// TODO: Publish the input using the configured function
// TODO: Fix issues while rezising: Stick to the bottom
// TODO: Fix Divider
