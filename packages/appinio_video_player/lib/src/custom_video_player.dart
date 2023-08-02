import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:appinio_video_player/src/embedded_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Widget? customControlWidget;

  const CustomVideoPlayer({
    Key? key,
    required this.customVideoPlayerController,
    this.customControlWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmbeddedVideoPlayer(
      isFullscreen: false,
      customVideoPlayerController: customVideoPlayerController,
      customControlWidget: customControlWidget,
    );
  }
}
