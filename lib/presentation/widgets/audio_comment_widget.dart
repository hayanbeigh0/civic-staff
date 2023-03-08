import 'dart:async';
import 'dart:developer';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioCommentWidget extends StatelessWidget {
  const AudioCommentWidget({
    super.key,
    required this.commentList,
    required this.commentListIndex,
  });
  final List<Comments> commentList;
  final int commentListIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: commentList[commentListIndex].commentedBy ==
                  AuthBasedRouting.afterLogin.userDetails!.staffID
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 200.w,
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(1, 1),
                  color: AppColors.cardShadowColor,
                ),
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(-1, -1),
                  color: AppColors.colorWhite,
                ),
              ],
              color: AppColors.colorPrimaryLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commentList[commentListIndex].commentedBy ==
                        AuthBasedRouting.afterLogin.userDetails!.staffID
                    ? const SizedBox()
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        child: Text(
                          '~ ${commentList[commentListIndex].commentedByName}',
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            color: AppColors.textColorDark,
                            fontFamily: 'LexendDeca',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ),
                Transform.translate(
                  offset: Offset(0, 5.h),
                  child: AudioComment(
                    audioUrl: commentList[commentListIndex]
                        .assets!
                        .audio!
                        .l![0]
                        .toString(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateFormatter.formatDateTime(
                      commentList[commentListIndex].createdDate.toString(),
                    ),
                    style: AppStyles.dateTextDarkStyle,
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

class AudioComment extends StatefulWidget {
  final String audioUrl;

  const AudioComment({
    super.key,
    required this.audioUrl,
  });
  @override
  AudioCommentState createState() => AudioCommentState();
}

class AudioCommentState extends State<AudioComment> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  late final StreamSubscription playerStateSubscription;
  late final StreamSubscription durationSubscription;
  late final StreamSubscription positionSubscription;
  late final StreamSubscription seekCompleteSubscription;
  @override
  void initState() {
    setAudio();
    playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying = event == PlayerState.playing;
      });
    });
    durationSubscription = _audioPlayer.onDurationChanged.listen((event) {
      log('${event.inSeconds.toDouble()}');
      setState(() {
        _duration = event;
      });
    });
    positionSubscription = _audioPlayer.onPositionChanged.listen((event) {
      _currentPosition = event;
    });
    seekCompleteSubscription = _audioPlayer.onSeekComplete.listen((event) {
      setState(() {
        _duration = const Duration(seconds: 0);
      });
    });
    super.initState();
  }

  void play() async {
    await _audioPlayer.play(UrlSource(widget.audioUrl));
    setState(() {
      _isPlaying = true;
    });
  }

  void pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isPlaying)
          IconButton(
            icon: const Icon(
              Icons.pause,
              size: 34,
            ),
            onPressed: pause,
          ),
        if (!_isPlaying)
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: 34.sp,
            ),
            onPressed: play,
          ),
        Expanded(
          child: SizedBox(
            height: 20.0.h,
            child: Slider(
              thumbColor: AppColors.colorPrimary,
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              value: _currentPosition.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
                setState(() {
                  _currentPosition = Duration(seconds: value.round());
                });
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
              activeColor: AppColors.colorPrimary,
              inactiveColor: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    durationSubscription.cancel();
    positionSubscription.cancel();
    seekCompleteSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void setAudio() async {
    _audioPlayer.setReleaseMode(ReleaseMode.release);
  }
}
