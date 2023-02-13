import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:civic_staff/presentation/widgets/comment_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoCommentWidget extends StatefulWidget {
  const VideoCommentWidget({
    super.key,
    required this.commentList,
    required this.commentListIndex,
  });
  final List commentList;
  final int commentListIndex;

  @override
  State<VideoCommentWidget> createState() => _VideoCommentWidgetState();
}

class _VideoCommentWidgetState extends State<VideoCommentWidget> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.network(
        widget.commentList[widget.commentListIndex].videoUrl.toString())
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
    super.initState();
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 150.h,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                // height: 150.h,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPlaying ? _controller.pause() : _controller.play();
                      });
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
              ),
              Positioned(
                right: 5.w,
                bottom: 5.h,
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.colorBlack200,
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                  child: Text(
                    DateFormatter.formatDateTime(
                      widget.commentList[widget.commentListIndex].timeStamp
                          .toString(),
                    ),
                    style: TextStyle(
                      color: AppColors.colorWhite,
                      fontFamily: 'LexendDeca',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
