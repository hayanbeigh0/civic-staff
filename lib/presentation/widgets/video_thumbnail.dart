import 'dart:developer';
import 'dart:io';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;
import 'package:path_provider/path_provider.dart';

class VideoThumbnail extends StatefulWidget {
  final String url;
  const VideoThumbnail(
      {super.key, required this.url, this.commentList, this.commentListIndex});
  final List<Comments>? commentList;
  final int? commentListIndex;

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  String? videoThumbnail;
  @override
  void initState() {
    super.initState();
    getVideoThumbnail();
  }

  getVideoThumbnail() async {
    videoThumbnail = await thumbnail.VideoThumbnail.thumbnailFile(
      video: widget.url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: thumbnail.ImageFormat.JPEG,
      maxHeight: 1024,
      quality: 100,
    );
    if (mounted) {
      setState(() {
        videoThumbnail;
      });
    }
    log(videoThumbnail.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.commentList![widget.commentListIndex!.toInt()].commentedBy ==
                  AuthBasedRouting.afterLogin.userDetails!.staffID
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: videoThumbnail != null
          ? Container(
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
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.colorPrimaryLight,
              ),
              width: 200.w,
              height: 150.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
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
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.colorPrimaryLight,
                        ),
                        height: 150.h,
                        width: 200.w,
                        child: Image.file(
                          File(
                            videoThumbnail.toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.black45,
                        child: Icon(
                          Icons.play_arrow,
                          size: 40.sp,
                          color: Colors.white,
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
                              widget.commentList![widget.commentListIndex!]
                                  .createdDate
                                  .toString(),
                            ),
                            style: AppStyles.dateTextWhiteStyle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 5.w,
                        top: 5.h,
                        child: widget.commentList![widget.commentListIndex!]
                                    .commentedBy ==
                                AuthBasedRouting.afterLogin.userDetails!.staffID
                            ? const SizedBox()
                            : Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3.sp),
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorBlack200,
                                      borderRadius: BorderRadius.circular(
                                        10.r,
                                      ),
                                    ),
                                    child: Text(
                                      '~ ${widget.commentList![widget.commentListIndex!].commentedByName}',
                                      style: TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: AppColors.colorWhite,
                                        fontFamily: 'LexendDeca',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.colorPrimaryLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              height: 100.h,
              width: 200.w,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.black45,
                  child: Icon(
                    Icons.play_arrow,
                    size: 40.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}
