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
    final JoystickDatamodell joystick = context.watch<SteeringProvider>().joystick;
    final int selectedPosition = context.watch<SteeringProvider>().selectedPosition;
    final List<CameraDatamodell> cameras = context.watch<SteeringProvider>().cameras;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height * 3) / 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display a list of all available cameras & highlight the selected one
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 6,
                  child: Material(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8.0),
                      child: ListView.separated(
                        itemCount: cameras.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(cameras[index].label),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            tileColor: theme.surfaceContainer,
                            selectedTileColor: theme.secondaryContainer,
                            selected: cameras[index].selected,
                            onTap: () {
                              // Select this one
                              context.read<SteeringProvider>().selectCamera(index, cameras[index].selected ? false : true);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                ),
                Expanded( // TODO: Replace by camera image
                  child: Center(
                    child: Text(cameras[selectedPosition].label)
                  )
                ),
                Container(
                  color: theme.surfaceContainer,
                  width: (MediaQuery.of(context).size.width) / 6,
                  child: ListView.separated( // Display vertical sliders
                    itemCount: horizontalSliders.length,
                    itemBuilder: (context, index) {
                      return SliderBox(
                        slider: horizontalSliders[index],
                        verticalOrientation: false,
                        onChangeEnd: (value) {
                          // TODO: Implement the slider
                          print(joystick);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 4.0),
                  ),
                ),
              ],
            ),
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

// TODO: Get the camera views from the configuration
// TODO: Define the relevant functions for steering
// TODO: Publish the input using the configured function
// TODO: Fix issues while rezising: Stick to the bottom
// TODO: Fix Divider
// TODO: Handle long slider labels
