import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class AssetVideoThumbnail extends StatefulWidget {
  final String url;
  const AssetVideoThumbnail({super.key, required this.url});

  @override
  State<AssetVideoThumbnail> createState() => _AssetVideoThumbnailState();
}

class _AssetVideoThumbnailState extends State<AssetVideoThumbnail> {
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
  }

  @override
  Widget build(BuildContext context) {
    return videoThumbnail != null
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
            // height: 150.h,
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
                      // height: 150.h,
                      width: 200.w,
                      child: Image.file(
                        File(
                          videoThumbnail.toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
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
          );
  }
}
