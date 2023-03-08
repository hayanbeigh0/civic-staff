import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
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
            // height: 150.h,
            width: 200.w,
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
                      commentList[commentListIndex]
                          .assets!
                          .image!
                          .l![0]
                          .s
                          .toString(),
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
                        commentList[commentListIndex].createdDate.toString(),
                      ),
                      style: AppStyles.dateTextWhiteStyle,
                    ),
                  ),
                ),
                Positioned(
                  left: 5.w,
                  top: 5.h,
                  child: commentList[commentListIndex].commentedBy ==
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
                                '~ ${commentList[commentListIndex].commentedByName}',
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
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}
