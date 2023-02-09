import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/photo_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/text_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/video_comment_widget.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    Key? key,
    // required this.commentListIndex,
    required this.commentList,
  }) : super(key: key);

  // final int commentListIndex;
  final List<dynamic> commentList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: commentList.length,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            commentList[index].text == ''
                ? const SizedBox()
                : TextCommentWidget(
                    commentList: commentList as dynamic,
                    commentListIndex: index,
                  ),
            commentList[index].imageUrl == ''
                ? const SizedBox()
                : PhotoCommentWidget(
                    commentList: commentList as dynamic,
                    commentListIndex: index,
                  ),
            commentList[index].videoUrl == ''
                ? const SizedBox()
                : VideoCommentWidget(
                    commentList: commentList as dynamic,
                    commentListIndex: index,
                  ),
            commentList[index].audioUrl == ''
                ? const SizedBox()
                : AudioCommentWidget(
                    commentList: commentList as dynamic,
                    commentListIndex: index,
                  ),
            SizedBox(
              height: 10.h,
            ),
            index < commentList.length - 1
                ? const Divider(
                    color: AppColors.colorGreyLight,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
