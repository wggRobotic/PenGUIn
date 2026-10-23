import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Play the video via RTSP
    player.open(Media("rtsp://viewer:view-only@192.168.2.122:554/Streaming/Channels/1")); // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller);
  }

  @override
  void dispose() {
    // Close the player
    player.dispose();
    super.dispose();
  }
}