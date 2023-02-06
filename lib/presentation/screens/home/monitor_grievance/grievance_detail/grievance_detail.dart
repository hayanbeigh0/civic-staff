import 'dart:async';

import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_add_comment.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_audio.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/secondary_button.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_my_comments.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_photo_video.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_reporter_comments.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/comment_list.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GrievanceDetail extends StatelessWidget {
  static const routeName = '/grievanceDetail';
  GrievanceDetail({
    super.key,
    required this.state,
    required this.grievanceListIndex,
  });
  GrievancesLoadedState state;
  final int grievanceListIndex;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: grievanceDetails(context),
    );
  }

  Column grievanceDetails(BuildContext context) {
    return Column(
      children: [
        PrimaryTopShape(
          height: 150.h,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 18.0.w,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SafeArea(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset(
                          'assets/icons/arrowleft.svg',
                          color: AppColors.colorWhite,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Grievance Detail',
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
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryDisplayField(
                    title: 'Grievance type',
                    value: state.grievanceList[grievanceListIndex].grievanceType
                        .toString(),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Divider(
                    height: 10.h,
                    color: AppColors.colorGreyLight,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  PrimaryDisplayField(
                    title: 'Raised by',
                    value: state.grievanceList[grievanceListIndex].raisedBy
                        .toString(),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PrimaryDisplayField(
                    title: 'Status',
                    value: state.grievanceList[grievanceListIndex].status
                        .toString(),
                    suffixIcon: TextButton(
                      child: Text(
                        'Change Status',
                        style: TextStyle(
                          color: AppColors.textColorRed,
                          fontFamily: 'LexendDeca',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PrimaryDisplayField(
                    title: 'Priority',
                    value: state.grievanceList[grievanceListIndex].priority
                        .toString(),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Photos / Videos',
                    style: TextStyle(
                      color: AppColors.textColorDark,
                      fontFamily: 'LexendDeca',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    height: 70.h,
                    child: Stack(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.grievanceList[grievanceListIndex]
                                  .photos!.length +
                              state.grievanceList[grievanceListIndex].videos!
                                  .length,
                          itemBuilder: (context, index) {
                            if (index <
                                state.grievanceList[grievanceListIndex].photos!
                                    .length) {
                              return Container(
                                clipBehavior: Clip.antiAlias,
                                height: 70.h,
                                width: 70.h,
                                margin: EdgeInsets.only(right: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Image.network(
                                  state.grievanceList[grievanceListIndex]
                                      .photos![index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return Container(
                                clipBehavior: Clip.antiAlias,
                                height: 70.h,
                                width: 70.h,
                                margin: EdgeInsets.only(right: 12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.colorPrimaryLight,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {},
                                ),
                              );
                            }
                          },
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(15, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    GrievancePhotoVideo.routeName,
                                    arguments: {
                                      "index": grievanceListIndex,
                                      "state": state,
                                    },
                                  );
                                },
                                child: Text(
                                  'View all',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontFamily: 'LexendDeca',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Voice / Audio',
                    style: TextStyle(
                      color: AppColors.textColorDark,
                      fontFamily: 'LexendDeca',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    height: 100.h,
                    child: Stack(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state
                              .grievanceList[grievanceListIndex].audios!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  height: 70.h,
                                  width: 70.h,
                                  margin: EdgeInsets.only(right: 12.w),
                                  padding: EdgeInsets.all(20.sp),
                                  decoration: BoxDecoration(
                                    color: AppColors.colorPrimaryLight,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svg/audiofile.svg',
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  'Audio - ${index + 1}',
                                  style: TextStyle(
                                    color: AppColors.textColorDark,
                                    fontFamily: 'LexendDeca',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: 100.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r),
                                ),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromARGB(0, 0, 0, 0),
                                    Color.fromARGB(255, 0, 0, 0),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      GrievanceAudio.routeName,
                                      arguments: {
                                        "index": grievanceListIndex,
                                        "state": state,
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View all',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontFamily: 'LexendDeca',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Location',
                    style: TextStyle(
                      color: AppColors.textColorDark,
                      fontFamily: 'LexendDeca',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  LocationMapField(
                    mapController: _controller,
                    latitude: double.parse(
                      state.grievanceList[grievanceListIndex].latitude
                          .toString(),
                    ),
                    longitude: double.parse(
                      state.grievanceList[grievanceListIndex].longitude
                          .toString(),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      color: AppColors.textColorDark,
                      fontFamily: 'LexendDeca',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      state.grievanceList[grievanceListIndex].description
                          .toString(),
                      style: TextStyle(
                        overflow: TextOverflow.fade,
                        color: AppColors.textColorDark,
                        fontFamily: 'LexendDeca',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        height: 1.1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Contact by phone enabled?',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        state.grievanceList[grievanceListIndex]
                                    .contactByPhoneEnabled ==
                                true
                            ? 'Yes'
                            : 'No',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Comments by the reporter',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            GrievanceReporterComments.routeName,
                            arguments: {
                              'reporterComments': state
                                  .grievanceList[grievanceListIndex]
                                  .reporterComments,
                            },
                          );
                        },
                        child: Text(
                          'View all',
                          style: TextStyle(
                            color: AppColors.textColorDark,
                            fontFamily: 'LexendDeca',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        CommentList(
                          commentList: state.grievanceList[grievanceListIndex]
                              .reporterComments as List<dynamic>,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'My Comments',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(GrievanceAddComment.routeName);
                        },
                        child: Text(
                          'Add comment',
                          style: TextStyle(
                            color: AppColors.textColorDark,
                            fontFamily: 'LexendDeca',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(
                              GrievanceMyComments.routeName,
                              arguments: {
                                'myComments': state
                                    .grievanceList[grievanceListIndex]
                                    .myComments,
                              },
                            ),
                            child: Text(
                              'View all',
                              style: TextStyle(
                                color: AppColors.textColorDark,
                                fontFamily: 'LexendDeca',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CommentList(
                          commentList: state.grievanceList[grievanceListIndex]
                              .myComments as List<dynamic>,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: BlocConsumer<GrievancesBloc, GrievancesState>(
                      listener: (context, grievanceClosing) {
                        if (grievanceClosing is GrievanceClosedState) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, grievanceClosing) {
                        if (grievanceClosing is ClosingGrievanceState) {
                          return SecondaryButton(
                            buttonText: 'Close grievance',
                            isLoading: true,
                            onTap: () {},
                          );
                        }
                        if (grievanceClosing is ClosingGrievanceFailedState) {
                          return SecondaryButton(
                            buttonText: 'Close grievance',
                            isLoading: false,
                            onTap: () {
                              BlocProvider.of<GrievancesBloc>(context).add(
                                CloseGrievanceEvent(
                                  grievanceId: state
                                      .grievanceList[grievanceListIndex]
                                      .grievanceId
                                      .toString(),
                                ),
                              );
                            },
                          );
                        }
                        return SecondaryButton(
                          buttonText: 'Close grievance',
                          isLoading: false,
                          onTap: () {
                            BlocProvider.of<GrievancesBloc>(context).add(
                              CloseGrievanceEvent(
                                grievanceId: state
                                    .grievanceList[grievanceListIndex]
                                    .grievanceId
                                    .toString(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
