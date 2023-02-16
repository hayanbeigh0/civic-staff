import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoCommentWidget extends StatelessWidget {
  const PhotoCommentWidget({
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
          // height: 150.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              SizedBox(
                // height: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: Image.network(
                    commentList[commentListIndex].imageUrl.toString(),
                    fit: BoxFit.cover,
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
                      commentList[commentListIndex].timeStamp.toString(),
                    ),
                    style: AppStyles.dateTextWhiteStyle,
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
