import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/get_temporary_directory.dart';
import 'package:civic_staff/presentation/utils/functions/image_and_video_compress.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/comment_list.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_dialog_button.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/progress_dialog_widget.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:images_picker/images_picker.dart';

class AllComments extends StatefulWidget {
  final String grievanceId;
  static const routeName = '/grievanceId';
  const AllComments({
    super.key,
    required this.grievanceId,
  });

  @override
  State<AllComments> createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  @override
  void initState() {
    super.initState();
    initAudioRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  List<XFile> images = [];
  List<XFile> videos = [];
  List<XFile> audios = [];
  List<Uint8List?> thumbnailBytes = [];
  int? videoSize;
  List<MediaInfo?> compressVideoInfo = [];
  final TextEditingController commentTextController = TextEditingController();
  List<Comments> comments = const [];
  final recorder = FlutterSoundRecorder();
  bool showSpinner = false;
  late StreamSubscription audioDurationSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<GrievancesBloc>(context).add(GetGrievanceByIdEvent(
              municipalityId:
                  AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
              grievanceId: widget.grievanceId));
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTopShape(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.sp),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/arrowleft.svg',
                                    color: AppColors.colorWhite,
                                    height: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    LocaleKeys.comments_screenTitle.tr(),
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
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
              child: Row(
                children: [
                  Text(
                    LocaleKeys.comments_allComments.tr(),
                    style: TextStyle(
                      color: AppColors.textColorDark,
                      fontFamily: 'LexendDeca',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<GrievancesBloc, GrievancesState>(
                    builder: (context, state) {
                      if (state is LoadingGrievanceByIdState) {
                        return IconButton(
                          onPressed: () {},
                          icon: SizedBox(
                            height: 24.sp,
                            width: 24.sp,
                            child: const Icon(
                              Icons.refresh,
                              color: AppColors.colorDisabledTextField,
                            ),
                          ),
                        );
                      }
                      return IconButton(
                        onPressed: () {
                          BlocProvider.of<GrievancesBloc>(context).add(
                            GetGrievanceByIdEvent(
                              municipalityId: AuthBasedRouting
                                  .afterLogin.userDetails!.municipalityID!,
                              grievanceId: widget.grievanceId,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.colorPrimary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: BlocConsumer<GrievancesBloc, GrievancesState>(
                listener: (context, state) {
                  if (state is GrievanceByIdLoadedState) {
                    comments = state.grievanceDetail.comments!.toList();
                  }
                  if (state is AddingGrievanceImageCommentAssetSuccessState) {
                    BlocProvider.of<GrievancesBloc>(context)
                        .add(AddGrievanceCommentEvent(
                      grievanceId: widget.grievanceId,
                      staffId:
                          AuthBasedRouting.afterLogin.userDetails!.staffID!,
                      name: AuthBasedRouting.afterLogin.userDetails!.firstName!,
                      assets: {
                        'Audio': const [],
                        'Image': [
                          '$CLOUDFRONT_URL/${state.s3uploadResult.uploadResult!.key1}',
                        ],
                        'Video': const []
                      },
                      comment: '',
                    ));
                  }
                  if (state is AddingGrievanceVideoCommentAssetSuccessState) {
                    log('Adding grievance video to s3 done!');
                    BlocProvider.of<GrievancesBloc>(context)
                        .add(AddGrievanceCommentEvent(
                      grievanceId: widget.grievanceId,
                      staffId:
                          AuthBasedRouting.afterLogin.userDetails!.staffID!,
                      name: AuthBasedRouting.afterLogin.userDetails!.firstName!,
                      assets: {
                        'Audio': const [],
                        'Image': const [],
                        'Video': [
                          '$CLOUDFRONT_URL/${state.s3uploadResult.uploadResult!.key1}'
                        ]
                      },
                      comment: '',
                    ));
                  }
                  if (state is AddingGrievanceAudioCommentAssetSuccessState) {
                    Navigator.of(context).pop();
                    BlocProvider.of<GrievancesBloc>(context)
                        .add(AddGrievanceCommentEvent(
                      grievanceId: widget.grievanceId,
                      staffId:
                          AuthBasedRouting.afterLogin.userDetails!.staffID!,
                      name: AuthBasedRouting.afterLogin.userDetails!.firstName!,
                      assets: {
                        'Audio': [
                          '$CLOUDFRONT_URL/${state.s3uploadResult.uploadResult!.key1}'
                        ],
                        'Image': const [],
                        'Video': const []
                      },
                      comment: '',
                    ));
                  }
                  if (state is GrievanceByIdLoadedState) {
                    comments = state.grievanceDetail.comments!.toList();
                  }
                  if (state is LoadingGrievanceByIdFailedState) {
                    SnackBars.errorMessageSnackbar(
                        context, LocaleKeys.addComment_addCommentFailed.tr());
                    BlocProvider.of<GrievancesBloc>(context).add(
                      GetGrievanceByIdEvent(
                        municipalityId: AuthBasedRouting
                            .afterLogin.userDetails!.municipalityID!,
                        grievanceId: widget.grievanceId,
                      ),
                    );
                  }
                  if (state is AddingGrievanceVideoCommentAssetFailedState) {
                    SnackBars.errorMessageSnackbar(
                        context, 'Uploading video failed.');
                  }
                },
                builder: (context, state) {
                  if (state is GrievanceByIdLoadedState) {
                    comments = state.grievanceDetail.comments!.toList();
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                      child: state.grievanceDetail.comments!.isEmpty
                          ? Center(
                              child:
                                  Text(LocaleKeys.addComment_noComments.tr()),
                            )
                          : showSpinner
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.colorPrimary,
                                  ),
                                )
                              : CommentList(commentList: comments),
                    );
                  }

                  if (state is AddingGrievanceCommentState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceVideoCommentAssetState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceAudioCommentAssetState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceImageCommentAssetState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }

                  if (state is LoadingGrievanceByIdState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceVideoCommentAssetSuccessState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceImageCommentAssetSuccessState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }
                  if (state is AddingGrievanceAudioCommentAssetSuccessState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                    child: comments.isEmpty
                        ? Center(
                            child: Text(LocaleKeys.addComment_noComments.tr()),
                          )
                        : Stack(
                            children: [
                              CommentList(commentList: comments),
                            ],
                          ),
                  );
                },
              ),
            ),
            Container(
              height: 70.h,
              decoration: const BoxDecoration(
                color: AppColors.colorWhite,
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: AppColors.cardShadowColor,
                            ),
                            BoxShadow(
                              offset: Offset(-2, -2),
                              blurRadius: 4,
                              color: AppColors.colorWhite,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: commentTextController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.colorPrimaryExtraLight,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.sp,
                              vertical: 10.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            hintText:
                                LocaleKeys.addComment_commentTexthint.tr(),
                            hintStyle: TextStyle(
                              color: AppColors.textColorLight,
                              fontFamily: 'LexendDeca',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                            suffixIcon:
                                BlocConsumer<GrievancesBloc, GrievancesState>(
                              listener: (context, state) {
                                if (mounted) {
                                  commentTextController.clear();
                                }
                              },
                              builder: (context, state) {
                                if (state is GrievanceByIdLoadedState) {
                                  return IconButton(
                                    onPressed: () {
                                      if (commentTextController
                                          .text.isNotEmpty) {
                                        BlocProvider.of<GrievancesBloc>(context)
                                            .add(
                                          AddGrievanceCommentEvent(
                                            grievanceId: widget.grievanceId,
                                            staffId: AuthBasedRouting
                                                .afterLogin.userDetails!.staffID
                                                .toString(),
                                            name: AuthBasedRouting.afterLogin
                                                .userDetails!.firstName
                                                .toString(),
                                            assets: const {},
                                            comment: commentTextController.text,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: AppColors.colorPrimary,
                                    ),
                                  );
                                }
                                return IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.colorDisabledTextField,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          enableFeedback: true,
                          onTap: () {
                            _showPicker(context);
                          },
                          child: const Icon(
                            Icons.attach_file,
                            color: AppColors.colorGreyLight,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          enableFeedback: true,
                          onTap: () {
                            _showAudioPicker(context);
                          },
                          child: const Icon(
                            Icons.mic,
                            color: AppColors.colorGreyLight,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
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
      ),
    );
  }

  Future<void> pickVideo() async {
    // final pickedFile = await ImagePicker().pickVideo(
    //   source: ImageSource.gallery,
    //   maxDuration: const Duration(minutes: 1),
    // );
    final pickedFile = await ImagesPicker.pick(
      pickType: PickType.video,
      maxTime: 180,
      count: 1,
      quality: 0.5,
    );
    if (pickedFile == null) return;
    final file = File(pickedFile.first.path);
    int sizeInBytes = await file.length();
    log('Picked file size: $sizeInBytes');
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 30) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Video size cannot be more than 30 MB'),
            actions: [
              Align(
                alignment: Alignment.bottomRight,
                child: PrimaryDialogButton(
                  buttonText: 'Ok',
                  onTap: () => Navigator.of(context).pop(),
                  isLoading: false,
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    generateThumbnail(file);
    // final size = getVideoSize(file);
    // log('Video size $size');
    File compressedFile = await compressVideo(file);

    int compressedSizeInBytes = await compressedFile.length();
    double compressedSizeInMb = compressedSizeInBytes / (1024 * 1024);
    log('Compressed file size: $compressedSizeInMb');
    final Uint8List videoBytes = await compressedFile.readAsBytes();
    final String base64Video = base64Encode(videoBytes);
    BlocProvider.of<GrievancesBloc>(context)
        .add(AddGrievanceVideoCommentAssetsEvent(
      grievanceId: widget.grievanceId,
      fileType: 'video',
      encodedCommentFile: base64Video,
    ));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> recordVideo() async {
    log('Opening recorder');
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 1),
    );
    if (pickedFile == null) {
      log('No file picked');
      return;
    }
    final file = File(pickedFile.path);
    int sizeInBytes = await file.length();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    log('Picked file size: $sizeInMb MB');
    if (sizeInMb > 30) {
      ImagesPicker.saveVideoToAlbum(file);
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Video size cannot be more than 30 MB'),
            actions: [
              Align(
                alignment: Alignment.bottomRight,
                child: PrimaryDialogButton(
                  buttonText: 'Ok',
                  onTap: () => Navigator.of(context).pop(),
                  isLoading: false,
                ),
              ),
            ],
          );
        },
      );
      return;
    }
    generateThumbnail(file);
    File compressedFile = await compressVideo(file);
    int compressedSizeInBytes = await compressedFile.length();
    double compressedSizeInMb = compressedSizeInBytes / (1024 * 1024);
    log('Compressed file size: $compressedSizeInMb');
    final Uint8List videoBytes = await compressedFile.readAsBytes();
    final String base64Video = base64Encode(videoBytes);
    BlocProvider.of<GrievancesBloc>(context)
        .add(AddGrievanceVideoCommentAssetsEvent(
      grievanceId: widget.grievanceId,
      fileType: 'video',
      encodedCommentFile: base64Video,
    ));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<int> getVideoSize(File file) async {
    final size = await file.length();
    setState(() {
      videoSize = size;
    });
    log('Video Size: $videoSize');
    return size;
  }

  Future<File> compressVideo(File file) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: ProgressDialogWidget(),
        );
      },
    );
    final info = await VideoCompressApi.compressVideo(file);
    // setState(() {
    //   compressVideoInfo.add(info);
    // });
    return File(info!.file!.path.toString());
    // log(compressVideoInfo!.filesize.toString());
  }

  Widget buildThumbnail(int index) {
    return thumbnailBytes == null
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.memory(
                    thumbnailBytes[index]!,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPlayer(
                            file: File(compressVideoInfo[index]!.file!.path),
                            url: null,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: AppColors.colorWhite,
                      size: 28.sp,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      videos.removeAt(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.textColorRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> generateThumbnail(File file) async {
    final thumbnailByte = await VideoCompress.getByteThumbnail(file.path);
    setState(() {
      thumbnailBytes.add(thumbnailByte);
    });
  }

  Future<void> pickPhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      images.add(pickedFile!);
    });
    log('Picking image');
    final Uint8List imageBytes = await pickedFile!.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    BlocProvider.of<GrievancesBloc>(context).add(
      AddGrievanceImageCommentAssetsEvent(
        grievanceId: widget.grievanceId,
        fileType: 'image',
        encodedCommentFile: base64Image,
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> capturePhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      images.add(pickedFile!);
    });
    final Uint8List imageBytes = await pickedFile!.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    BlocProvider.of<GrievancesBloc>(context).add(
      AddGrievanceImageCommentAssetsEvent(
        grievanceId: widget.grievanceId,
        fileType: 'image',
        encodedCommentFile: base64Image,
      ),
    );
    // await GrievancesRepository().addGrievanceCommentFile(
    //   encodedCommentFile: base64Image,
    //   fileType: 'image',
    //   grievanceId: widget.grievanceId,
    // );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 100.w,
                child: const Divider(
                  thickness: 2,
                  color: AppColors.textColorDark,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.sp),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: Text(LocaleKeys.addComment_photoLibrary.tr()),
                      onTap: () async {
                        await pickPhoto();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: Text(LocaleKeys.addComment_camera.tr()),
                      onTap: () async {
                        await capturePhoto();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.videocam),
                      title: Text(LocaleKeys.addComment_videoLibrary.tr()),
                      onTap: () async {
                        await pickVideo();
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.videocam),
                      title: Text(LocaleKeys.addComment_recordVideo.tr()),
                      onTap: () async {
                        await recordVideo();
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAudioPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 100.w,
                child: const Divider(
                  thickness: 2,
                  color: AppColors.textColorDark,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.sp),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.audio_file),
                      title: Text(LocaleKeys.addComment_chooseAudio.tr()),
                      onTap: () async {
                        await chooseAudio();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.record_voice_over),
                      title: Text(LocaleKeys.addComment_recordAudio.tr()),
                      onTap: () async {
                        await recordAudio();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> chooseAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      int sizeInBytes = result.files.first.size;
      double sizeInMb = sizeInBytes / (1024 * 1024);
      log('Picked file size: $sizeInMb MB');
      if (sizeInMb > 5) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text('Video size cannot be more than 5 MB'),
              actions: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: PrimaryDialogButton(
                    buttonText: 'Ok',
                    onTap: () => Navigator.of(context).pop(),
                    isLoading: false,
                  ),
                ),
              ],
            );
          },
        );
        return;
      }
      final file = result.files.single;
      audios.add(
        XFile(
          file.path.toString(),
        ),
      );
      final Uint8List audioBytes =
          await File(file.path.toString()).readAsBytes();
      final String base64Audio = base64Encode(audioBytes);
      BlocProvider.of<GrievancesBloc>(context).add(
        AddGrievanceAudioCommentAssetsEvent(
          encodedCommentFile: base64Audio,
          fileType: 'audio',
          grievanceId: widget.grievanceId,
        ),
      );
      // Do something with the selected audio file, e.g. play it
      log('Selected audio file: ${file.path}');
    } else {
      // User canceled the picker
      log('No audio file selected');
    }
  }

  Future<void> recordAudio() async {
    File? audioFile;
    bool recordingAudio = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, dialogState) {
              return audioFile != null && recorder.isStopped
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocaleKeys.addComment_recordingDoneMessage.tr(),
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.colorPrimaryLight,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: AudioComment(
                            audioUrl: audioFile!.path,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        BlocConsumer<GrievancesBloc, GrievancesState>(
                          listener: (context, state) {
                            // if (state
                            //     is AddingGrievanceAudioCommentAssetSuccessState) {
                            //   Navigator.of(context).pop();
                            //   BlocProvider.of<GrievancesBloc>(context)
                            //       .add(AddGrievanceCommentEvent(
                            //     grievanceId: widget.grievanceId,
                            //     staffId: AuthBasedRouting
                            //         .afterLogin.userDetails!.staffID!,
                            //     name: AuthBasedRouting
                            //         .afterLogin.userDetails!.firstName!,
                            //     assets: {
                            //       'Audio': [
                            //         '$CLOUDFRONT_URL/${state.s3uploadResult.uploadResult!.key1}'
                            //       ],
                            //       'Image': const [],
                            //       'Video': const []
                            //     },
                            //     comment: '',
                            //   ));
                            // }
                          },
                          builder: (context, state) {
                            if (state
                                is AddingGrievanceAudioCommentAssetState) {
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: PrimaryDialogButton(
                                  onTap: () {},
                                  buttonText: 'Upload',
                                  isLoading: true,
                                ),
                              );
                            }
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: PrimaryDialogButton(
                                onTap: () async {
                                  final Uint8List audioBytes =
                                      await File(audioFile!.path.toString())
                                          .readAsBytes();
                                  final String base64Audio =
                                      base64Encode(audioBytes);
                                  BlocProvider.of<GrievancesBloc>(context).add(
                                    AddGrievanceAudioCommentAssetsEvent(
                                      encodedCommentFile: base64Audio,
                                      fileType: 'audio',
                                      grievanceId: widget.grievanceId,
                                    ),
                                  );
                                },
                                buttonText:
                                    LocaleKeys.addComment_uploadRecoding.tr(),
                                isLoading: false,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        StreamBuilder<RecordingDisposition>(
                          stream: recorder.onProgress,
                          builder: (context, snapshot) {
                            final duration = snapshot.hasData
                                ? snapshot.data!.duration
                                : Duration.zero;
                            String twoDigits(int n) =>
                                n.toString().padLeft(2, '0');
                            final twoDigitMinutes =
                                twoDigits(duration.inMinutes.remainder(60));
                            final twoDigitSeconds =
                                twoDigits(duration.inSeconds.remainder(60));

                            return Text(
                              '$twoDigitMinutes : $twoDigitSeconds',
                              style: TextStyle(
                                fontSize: 28.sp,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            if (recorder.isRecording) {
                              audioDurationSubscription.cancel();
                              dialogState(() {
                                recordingAudio = false;
                              });
                              audioFile = await stopAudioRecording();
                              await recorder.closeRecorder();
                              audios.add(XFile(audioFile!.path));
                              int sizeInBytes = audioFile!.lengthSync();
                              double sizeInMb = sizeInBytes / (1024 * 1024);
                              log('Recorded audio file size: $sizeInMb MB');
                            }
                            if (!recorder.isRecording) {
                              dialogState(() {
                                recordingAudio = true;
                              });
                              await initAudioRecorder();
                              await recorder.startRecorder(
                                codec: Codec.aacMP4,
                                toFile:
                                    await getTemporaryFilePath(audios.length),
                              );
                              audioDurationSubscription =
                                  recorder.onProgress!.listen(
                                (event) async {
                                  if (event.duration >=
                                      const Duration(seconds: 60)) {
                                    audioFile = await stopAudioRecording();
                                    await recorder.closeRecorder();
                                    audios.add(XFile(audioFile!.path));
                                    int sizeInBytes = audioFile!.lengthSync();
                                    double sizeInMb =
                                        sizeInBytes / (1024 * 1024);
                                    log('Recorded audio file size: $sizeInMb MB');
                                    if (mounted) {
                                      dialogState(() {
                                        audioDurationSubscription.cancel();
                                        recordingAudio = false;
                                      });
                                    }
                                    // return;
                                  }
                                },
                              );
                            }
                          },
                          icon: recordingAudio
                              ? Icon(
                                  Icons.stop_circle_outlined,
                                  color: AppColors.textColorRed,
                                  size: 50.sp,
                                )
                              : Icon(
                                  Icons.circle,
                                  color: AppColors.textColorRed,
                                  size: 50.sp,
                                ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          recordingAudio
                              ? LocaleKeys.addComment_stop.tr()
                              : LocaleKeys.addComment_record.tr(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Max duration allowed = 60 seconds.',
                          style: AppStyles.listOrderedByTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    );
            },
          ),
        );
      },
    );
    // recorder.dispositionStream();
  }

  Future<File> stopAudioRecording() async {
    recorder.dispositionStream();
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    log('Recorded audio: $audioFile');
    return audioFile;
  }

  Future<void> initAudioRecorder() async {
    final storageStatus = await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted ||
        storageStatus != PermissionStatus.granted) {
      throw 'Microphone Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(
      const Duration(
        milliseconds: 500,
      ),
    );
  }
}
