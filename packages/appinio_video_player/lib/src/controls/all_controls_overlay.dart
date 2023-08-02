import 'package:appinio_video_player/src/controls/control_bar.dart';
import 'package:appinio_video_player/src/controls/video_settings_button.dart';
import 'package:appinio_video_player/src/custom_video_player_controller.dart';
import 'package:flutter/material.dart';

class AllControlsOverlay extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  final Function updateVideoState;
  final Widget? customControlWidget;
  const AllControlsOverlay({
    Key? key,
    required this.customVideoPlayerController,
    required this.updateVideoState,
    this.customControlWidget,
  }) : super(key: key);

  @override
  State<AllControlsOverlay> createState() => _AllControlsOverlayState();
}

class _AllControlsOverlayState extends State<AllControlsOverlay> {
  bool _controlsVisible = true;
  int _visibilityToggleCounter = 0;

  @override
  void initState() {
    super.initState();
    _fadeOutControls();
    widget.customVideoPlayerController.isPlayingNotifier
        .addListener(_listenToPlayStateChanges);
  }

  @override
  void dispose() {
    widget.customVideoPlayerController.isPlayingNotifier
        .removeListener(_listenToPlayStateChanges);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _toggleControlsVisibility(context),
      child: Container(
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          child: _controlsVisible
              ? Stack(
                  children: [
                    if (widget.customControlWidget != null)
                      widget.customControlWidget!,
                    Padding(
                      padding: widget.customVideoPlayerController
                          .customVideoPlayerSettings.controlsPadding,
                      child: Column(
                        children: [
                          if (widget
                              .customVideoPlayerController
                              .customVideoPlayerSettings
                              .settingsButtonAvailable)
                            Align(
                              alignment: Alignment.topLeft,
                              child: VideoSettingsButton(
                                customVideoPlayerController:
                                    widget.customVideoPlayerController,
                                updateVideoState: widget.updateVideoState,
                              ),
                            ),
                          const Spacer(),
                          if (widget.customVideoPlayerController
                              .customVideoPlayerSettings.controlBarAvailable)
                            CustomVideoPlayerControlBar(
                              customVideoPlayerController:
                                  widget.customVideoPlayerController,
                              updateVideoState: widget.updateVideoState,
                              fadeOutOnPlay: _fadeOutControls,
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  void _listenToPlayStateChanges() {
    if (widget.customVideoPlayerController.isPlayingNotifier.value) {
      _fadeOutControls();
    }
  }

  void _toggleControlsVisibility(BuildContext context) {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) {
      _fadeOutControls();
    }
  }

  Future<void> _fadeOutControls() async {
    _visibilityToggleCounter++;
    await Future.delayed(
        widget.customVideoPlayerController.customVideoPlayerSettings
            .durationAfterControlsFadeOut, () {
      _visibilityToggleCounter--;

      // only toggle visibility if the video is playing
      if (widget.customVideoPlayerController.customVideoPlayerSettings
              .autoFadeOutControls &&
          widget.customVideoPlayerController.videoPlayerController.value
              .isPlaying) {
        if (_controlsVisible && _visibilityToggleCounter == 0) {
          if (mounted) {
            setState(() {
              _controlsVisible = false;
            });
          }
        }
      }
    });
  }
}
