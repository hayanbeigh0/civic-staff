import 'dart:io';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_bottom_shape.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GrievanceAddComment extends StatefulWidget {
  static const routeName = '/grievanceAddComment';
  GrievanceAddComment({
    super.key,
    required this.grievanceId,
  });
  final String grievanceId;

  @override
  State<GrievanceAddComment> createState() => _GrievanceAddCommentState();
}

class _GrievanceAddCommentState extends State<GrievanceAddComment> {
  final TextEditingController commentTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  XFile? image;
  XFile? video;
  bool recordingAudio = false;

  final recorder = FlutterSoundRecorder();
  @override
  void initState() {
    initAudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  List<Widget> attachments = [];
  GlobalKey imageWidget = GlobalKey();
  GlobalKey videoWidget = GlobalKey();
  GlobalKey audioWidget = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PrimaryTopShape(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            color: AppColors.colorWhite,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Add Comment',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment',
                      style: TextStyle(
                        color: AppColors.textColorDark,
                        fontFamily: 'LexendDeca',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 30.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: AppColors.colorPrimaryLight,
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            maxLines: 6,
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                              color: AppColors.textColorDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                            ),
                            maxLength: 300,
                            controller: commentTextController,
                            enabled: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.colorPrimaryLight,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.sp,
                                vertical: 10.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Your text goes here...",
                              hintMaxLines: 1,
                              errorStyle: AppStyles.errorTextStyle,
                              hintStyle: TextStyle(
                                overflow: TextOverflow.fade,
                                color: AppColors.textColorLight,
                                fontFamily: 'LexendDeca',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              children: [
                                image == null
                                    ? SizedBox(
                                        width: 30.w,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          getCameraImage()
                                                              .then((value) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Use camera',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          getGalleryImage()
                                                              .then(
                                                            (_) => Navigator.of(
                                                                    context)
                                                                .pop(),
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Upload from gallery',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.photo,
                                            size: 18.sp,
                                            color: AppColors.colorPrimary,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                video == null
                                    ? SizedBox(
                                        width: 30.w,
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          getCameraVideo();
                                                        },
                                                        child: const Text(
                                                          'Use camera',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          getGalleryVideo()
                                                              .then(
                                                            (_) => Navigator.of(
                                                                    context)
                                                                .pop(),
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Upload from gallery',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.video_camera_back,
                                            size: 18.sp,
                                            color: AppColors.colorPrimary,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  width: 30.w,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: StatefulBuilder(builder:
                                                (context, dialogState) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if (recorder
                                                          .isRecording) {
                                                        stopAudioRecording();
                                                        dialogState(() {
                                                          recordingAudio =
                                                              false;
                                                        });
                                                      }
                                                      if (!recorder
                                                          .isRecording) {
                                                        recordAudio();
                                                        dialogState(() {
                                                          recordingAudio = true;
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.mic,
                                                      size: 50.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    recordingAudio
                                                        ? 'Stop'
                                                        : 'Record',
                                                  ),
                                                  SizedBox(
                                                    height: 20.h,
                                                  ),
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.audio_file,
                                      size: 18.sp,
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'Attchments',
                          style: TextStyle(
                            color: AppColors.textColorDark,
                            fontFamily: 'LexendDeca',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 100.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.colorPrimaryLight,
                      ),
                      child: attachments.isNotEmpty
                          ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: attachments,
                            )
                          : const Center(
                              child: Text(
                                'No attchments!',
                                style: TextStyle(color: AppColors.colorPrimary),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PrimaryButton(
                        onTap: () {},
                        buttonText: 'Add Comment',
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PrimaryBottomShape(
        height: 80.h,
      ),
    );
  }

  Future<void> getCameraImage() async {
    image = await _picker.pickImage(
      source: ImageSource.camera,
    );
    attachments.add(
      Stack(
        key: imageWidget,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: 100.w,
            height: 80.h,
            child: Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: 30.sp,
              width: 40.sp,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    image = null;
                    attachments.removeWhere(
                      (element) => element.key == imageWidget,
                    );
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.textColorRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    setState(() {
      image = image;
      attachments = attachments;
    });
  }

  Future<void> getGalleryImage() async {
    image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      image = image;
    });
    attachments.add(
      Stack(
        key: imageWidget,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: 100.w,
            height: 80.h,
            child: Image.file(
              File(image!.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              height: 30.sp,
              width: 40.sp,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    image = null;
                    attachments.removeWhere(
                      (element) => element.key == imageWidget,
                    );
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.textColorRed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    setState(() {
      image = image;
      attachments = attachments;
    });
  }

  Future<void> getCameraVideo() async {
    video = await _picker.pickVideo(
      source: ImageSource.camera,
    );
    attachments.add(
      Stack(
        key: videoWidget,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: 100.w,
            height: 80.h,
            child: Image.file(
              File(video!.path),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  video = null;
                  attachments.removeWhere(
                    (element) => element.key == videoWidget,
                  );
                });
              },
              icon: const Icon(
                Icons.delete,
                color: AppColors.textColorRed,
              ),
            ),
          ),
        ],
      ),
    );
    setState(() {
      attachments = attachments;
      video = video;
    });
  }

  Future<void> getGalleryVideo() async {
    video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    attachments.add(
      Stack(
        key: videoWidget,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: 100.w,
            height: 80.h,
            child: Image.file(
              File(video!.path),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_arrow,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  video = null;
                  attachments.removeWhere(
                    (element) => element.key == videoWidget,
                  );
                });
              },
              icon: const Icon(
                Icons.delete,
                color: AppColors.textColorRed,
              ),
            ),
          ),
        ],
      ),
    );
    setState(() {
      attachments = attachments;
      video = video;
    });
  }

  Future<void> getGalleryAudio() async {
    video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    setState(() {
      video = video;
    });
  }

  Future<void> recordAudio() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future<void> stopAudioRecording() async {
    await recorder.stopRecorder();
  }

  void initAudioRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone Permission not granted';
    }
    await recorder.openRecorder();
  }
}
