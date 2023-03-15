import 'package:civic_staff/main.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/video_thumbnail.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/photo_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/text_comment_widget.dart';

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
            commentList[index].assets == null
                ? const SizedBox()
                : commentList[index].assets!.image == null ||
                        commentList[index].assets!.image == [] ||
                        commentList[index].assets!.image!.isEmpty
                    ? const SizedBox()
                    : PhotoCommentWidget(
                        commentList: commentList,
                        commentListIndex: index,
                      ),
            commentList[index].assets == null
                ? const SizedBox()
                : commentList[index].assets!.video == null ||
                        commentList[index].assets!.video == [] ||
                        commentList[index].assets!.video!.isEmpty
                    ? const SizedBox()
                    : Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FullScreenVideoPlayer(
                                  url: commentList[index].assets!.video![0],
                                  file: null,
                                ),
                              ));
                            },
                            child: Align(
                              alignment: commentList[index].commentedBy ==
                                      AuthBasedRouting
                                          .afterLogin.userDetails!.staffID
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 200.w,
                                height: 150.h,
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
                                child: VideoThumbnail(
                                  url: commentList[index].assets!.video![0],
                                  commentList: commentList,
                                  commentListIndex: index,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
            commentList[index].assets == null
                ? const SizedBox()
                : commentList[index].assets!.audio == null ||
                        commentList[index].assets!.audio == [] ||
                        commentList[index].assets!.audio!.isEmpty
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
