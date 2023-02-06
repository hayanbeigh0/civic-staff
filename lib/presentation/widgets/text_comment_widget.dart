import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextCommentWidget extends StatelessWidget {
  const TextCommentWidget({
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
          width: double.infinity,
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
              Text(
                commentList[commentListIndex].text.toString(),
                style: TextStyle(
                  overflow: TextOverflow.fade,
                  color: AppColors.textColorDark,
                  fontFamily: 'LexendDeca',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormatter.formatDateTime(
                    commentList[commentListIndex].timeStamp.toString(),
                  ),
                  style: TextStyle(
                    overflow: TextOverflow.fade,
                    color: AppColors.textColorDark,
                    fontFamily: 'LexendDeca',
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w300,
                    height: 1.1,
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
