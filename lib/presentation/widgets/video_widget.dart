import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.url,
  });
  final String url;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool isPlaying = false;
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      widget.url,
    );
    _videoPlayerController.setVolume(0);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowMuting: true,
      looping: false,
      showControls: false,
      aspectRatio: 1,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
    );
  }

  @override
  void dispose() {
    // Dispose the chewie and video player controllers when the widget is disposed
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            // height: 150.h,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Stack(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPlayer(
                          chewieController: _chewieController,
                          videoPlayerController: _videoPlayerController,
                        ),
                      ),
                    );
                  },
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                Positioned(
                  // top: 0,
                  bottom: 0,
                  right: 0,
                  // left: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenVideoPlayer(
                              chewieController: _chewieController,
                              videoPlayerController: _videoPlayerController,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.fullscreen,
                        color: AppColors.colorWhite,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  ChewieController chewieController;
  VideoPlayerController videoPlayerController;

  FullScreenVideoPlayer({
    Key? key,
    required this.chewieController,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();

    widget.videoPlayerController.setVolume(50);
    widget.chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoPlay: true,
      allowMuting: true,
      looping: false,
      showControls: true,
      aspectRatio: 1,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: widget.chewieController,
      ),
    );
  }

  // @override
  // void dispose() {
  //   widget.chewieController.dispose();
  //   widget.videoPlayerController.dispose();
  //   super.dispose();
  // }
}
