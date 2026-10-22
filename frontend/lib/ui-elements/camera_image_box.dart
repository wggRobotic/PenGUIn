import 'package:flutter/material.dart';
import 'package:vlc_player/vlc_player.dart';

class CameraImageBox extends StatefulWidget{
  const CameraImageBox({super.key});

  @override
  State<CameraImageBox> createState() => _CameraImageBoxState();
}

class _CameraImageBoxState extends State<CameraImageBox> {
  // Get a controller and open a connection
  late final VlcPlayerController controller;

  @override
  void initState() {
    // Create the controller and open a connection
    controller = VlcPlayerController(
      mediaSource: VlcMediaSource(uri: Uri.parse("rtsp://127.0.0.1:8554/test")), // TODO
      autoPlay: true,
      options: ["--rtsp-tcp"],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VlcPlayer(
        controller: controller,
        fit: VlcVideoFit.fill, // TODO: Test this
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller
    controller.dispose();
    super.dispose();
  }
}
