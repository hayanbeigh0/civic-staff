import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/photo_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/text_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/video_comment_widget.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    Key? key,
    // required this.commentListIndex,
    required this.commentList,
  }) : super(key: key);

  // final int commentListIndex;
  final List<Comments> commentList;

  @override
  Widget build(BuildContext context) {
    commentList.sort((a, b) {
      return b.createdDate!.compareTo(a.createdDate!);
    });
    return SizedBox(
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: commentList.length,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            commentList[index].comment == ''
                ? const SizedBox()
                : TextCommentWidget(
                    commentList: commentList,
                    commentListIndex: index,
                  ),
            commentList[index].assets!.image == null
                ? const SizedBox()
                : PhotoCommentWidget(
                    commentList: commentList,
                    commentListIndex: index,
                  ),
            commentList[index].assets!.video == null
                ? const SizedBox()
                : VideoCommentWidget(
                    commentList: commentList,
                    commentListIndex: index,
                  ),
            commentList[index].assets!.audio == null
                ? const SizedBox()
                : AudioCommentWidget(
                    commentList: commentList,
                    commentListIndex: index,
                  ),
            SizedBox(
              height: 10.h,
            ),
            // index < commentList.length - 1
            //     ? const Divider(
            //         color: AppColors.colorGreyLight,
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
