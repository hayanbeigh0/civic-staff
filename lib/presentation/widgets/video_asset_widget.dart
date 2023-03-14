import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoAssetWidget extends StatefulWidget {
  const VideoAssetWidget({super.key, required this.url});
  final String url;

  @override
  State<VideoAssetWidget> createState() => _VideoAssetWidgetState();
}

class _VideoAssetWidgetState extends State<VideoAssetWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          isPlaying = false;
        });
      });
    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          isPlaying = true;
        });
      }
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
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

    super.initState();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150.h,
      width: 200.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.colorPrimary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            // height: double.infinity,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                // setState(() {
                //   isPlaying ? _controller.pause() : _controller.play();
                // });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenVideoPlayer(
                      file: null,
                      url: widget.url,
                    ),
                  ),
                );
              },
              icon: isPlaying
                  ? const SizedBox()
                  : Icon(
                      Icons.play_arrow,
                      color: AppColors.colorWhite,
                      size: 50.sp,
                    ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenVideoPlayer(
                        file: null,
                        url: widget.url,
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
    );
  }
}
