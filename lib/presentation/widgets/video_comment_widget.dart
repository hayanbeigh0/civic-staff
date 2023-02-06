import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoCommentWidget extends StatelessWidget {
  const VideoCommentWidget({
    super.key,
    required this.commentList,
    required this.commentListIndex,
  });
  final List commentList;
  final int commentListIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150.h,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.colorPrimary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.play_arrow,
                  color: AppColors.colorWhite,
                  size: 34.sp,
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
                      commentList[commentListIndex].timeStamp.toString(),
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
}
