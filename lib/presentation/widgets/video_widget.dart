import 'dart:io';

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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FullScreenVideoPlayer(
                    //       chewieController: _chewieController,
                    //       videoPlayerController: _videoPlayerController,
                    //     ),
                    //   ),
                    // );
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => FullScreenVideoPlayer(
                        //       chewieController: _chewieController,
                        //       videoPlayerController: _videoPlayerController, file: null,
                        //     ),
                        //   ),
                        // );
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
  File file;

  FullScreenVideoPlayer({
    Key? key,
    // required this.chewieController,
    // required this.videoPlayerController,
    required this.file,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(
      widget.file,
    );
    videoPlayerController.setVolume(50);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      fullScreenByDefault: true,
      autoInitialize: true,
      allowFullScreen: true,
      zoomAndPan: true,
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
    chewieController.enterFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Chewie(
                controller: chewieController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    chewieController.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }
}
