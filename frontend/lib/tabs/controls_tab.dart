import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/datamodells.dart';
import 'package:frontend/storage/rosbridge_connector.dart';
import 'package:frontend/ui-elements/slider_box.dart';
import 'package:provider/provider.dart';

class ControlsTab extends StatelessWidget{
  const ControlsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    final List<SliderDatamodell> horizontalSliders = context.watch<ControlsProvider>().horizontalSliders;
    final List<SliderDatamodell> verticalSliders = context.watch<ControlsProvider>().verticalSliders;
    final JoystickDatamodell joystick = context.watch<ControlsProvider>().joystick;
    final int selectedPosition = context.watch<ControlsProvider>().selectedPosition;
    final List<CameraDatamodell> cameras = context.watch<ControlsProvider>().cameras;

    final double overallWidth = MediaQuery.of(context).size.width;
    final double sideBarSize = overallWidth / 6;

    final ScrollController controller = ScrollController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display a list of all available cameras & highlight the selected one
                SizedBox(
                  width: sideBarSize,
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
                              context.read<ControlsProvider>().selectCamera(index, cameras[index].selected ? false : true);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 2.0,
                  thickness: 2.0,
                ),
                Expanded( // TODO: Replace by camera image
                  child: Center(
                    child: Text(cameras[selectedPosition].label)
                  )
                ),
                VerticalDivider(
                  width: 2.0,
                  thickness: 2.0,
                ),
                SizedBox(
                  width: sideBarSize,
                  child: ListView.separated( // Display vertical sliders
                    itemCount: horizontalSliders.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return SliderBox(
                        slider: horizontalSliders[index],
                        verticalOrientation: false,
                        fixedWidth: sideBarSize - 16,
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
          Divider(
            height: 2.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: sideBarSize + 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    size: sideBarSize,
                  ),
                  stick: JoystickStick(
                    decoration: JoystickStickDecoration(color: theme.primary),
                    size: 50,
                  ),
                  listener: (input) {
                    // Publish the input depending on the configuration
                    RosbridgeConnector().publishJoystickInput(context, joystick.function, input.x, input.y);
                  }
                ),
                VerticalDivider(
                  width: 2.0,
                  thickness: 2.0,
                ),
                Expanded(
                  child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        // Get how far the user can and how far the user wants to scroll
                        final newOffset = controller.offset + event.scrollDelta.dy;
                        final maxScroll = controller.position.maxScrollExtent;
                        final minScroll = controller.position.minScrollExtent;
                        // Scroll, but take care of beeing between the start and the end
                        controller.jumpTo(newOffset.clamp(minScroll, maxScroll));
                      }
                    },
                    child: ListView.separated( // Display as mutch vertical sliders as configured
                      controller: controller,
                      itemCount: verticalSliders.length,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      padding: EdgeInsetsGeometry.all(8.0),
                      itemBuilder: (context, index) {
                        return SliderBox(
                          slider: verticalSliders[index],
                          verticalOrientation: true,
                          fixedWidth: sideBarSize / 3,
                          onChangeEnd: (value) {
                            // TODO: Implement the slider
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 4.0),
                    ),
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

// TODO: Define the relevant functions
// TODO: Publish the input using the configured function
