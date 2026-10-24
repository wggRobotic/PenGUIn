import 'package:flutter/material.dart';
import 'package:frontend/custom_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

class RtspCameraLiveViewBox extends StatefulWidget {
  const RtspCameraLiveViewBox({super.key,});

  @override
  State<RtspCameraLiveViewBox> createState() => _RtspCameraLiveViewBoxState();
}

class _RtspCameraLiveViewBoxState extends State<RtspCameraLiveViewBox> {
  // Create a control playback as well as a controller to handle it
  late Player player = Player();
  late VideoController controller = VideoController(player);
  bool fullscreenEnabled = false;

  @override
  Widget build(BuildContext context) {
    controller = VideoController(context.watch<ControlsProvider>().mediaKitPlayer);

    return Video(
      controller: controller,
      controls: (state) {
        return Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            onPressed: () {
              // Toggle the fullscreen
              state.toggleFullscreen();
              // Update the displayed button
              setState(() {
                if (fullscreenEnabled) {
                  fullscreenEnabled = false;
                } else {
                  fullscreenEnabled = true;
                }
              });
            },
            icon: Icon(fullscreenEnabled
              ? Icons.fullscreen_exit_outlined
              : Icons.fullscreen_outlined
            )
          ),
        );
      },
    );
  }
}

// TODO: Follow these instructions to support further plattforms: https://pub.dev/packages/media_kit#permissions