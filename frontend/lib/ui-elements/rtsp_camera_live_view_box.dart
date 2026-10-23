import 'package:flutter/material.dart';
import 'package:frontend/ui-elements/error_snackbar.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class RtspCameraLiveViewBox extends StatefulWidget {
  const RtspCameraLiveViewBox({super.key});

  @override
  State<RtspCameraLiveViewBox> createState() => _RtspCameraLiveViewBoxState();
}

class _RtspCameraLiveViewBoxState extends State<RtspCameraLiveViewBox> {
  // Create a control playback as well as a controller to handle it
  late final player = Player();
  late final controller = VideoController(player);
  bool fullscreenEnabled = false;

  @override
  void initState() {
    super.initState();
    createMediaKitPlayer(context);
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  void dispose() {
    // Close the player
    player.dispose();
    super.dispose();
  }

  Future<void> createMediaKitPlayer(BuildContext context) async {
    try {
      // Reduce latency
      final platform = player.platform;
      if (platform is NativePlayer) {
        await platform.setProperty("profile", "low-latency");
        await platform.setProperty("cache", "no");
        await platform.setProperty("demuxer-readahed-secs", "0");
        await platform.setProperty("audio", "no");
      }

      // Remove unused functionality
      await player.setAudioTrack(AudioTrack.no());
      await player.setSubtitleTrack(SubtitleTrack.no());

      // Play the video via RTSP
      await player.open(Media("rtsp://viewer:view-only@192.168.2.122:554/Streaming/Channels/1")); // TODO: 
    } catch (e) {
      // Display an error message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackbar().buildErrorSnackBar(context: context, error: "Couldn't get the RTSP stream"));
    }
  }
}

// TODO: Follow these instructions to support further plattforms: https://pub.dev/packages/media_kit#permissions