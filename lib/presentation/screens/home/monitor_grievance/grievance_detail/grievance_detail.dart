import 'dart:async';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_text_field.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_add_comment.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_my_comments.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_reporter_comments.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_audio.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_photo_video.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/photo_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/secondary_button.dart';
import 'package:civic_staff/presentation/widgets/text_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/video_comment_widget.dart';

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
  List<String> statusList = ['Processing', 'Completed'];
  List<String> expectedCompletionList = ['1 Day', '2 Days', '3 Days'];
  List<String> priorityList = ['Immediate', 'Low', 'High'];
  List<String> grievanceTypes = [
    'Road Maintainance',
    'Garbage Collection',
    'Street Lighting'
  ];
  late String statusDropdownValue;
  late String expectedCompletionDropdownValue;
  late String priorityDropdownValue;
  late String grievanceTypeDropdownValue;

  bool showDropdownError = false;
  TextEditingController reporterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    reporterController.text =
        state.grievanceList[grievanceListIndex].raisedBy.toString();
    statusDropdownValue =
        state.grievanceList[grievanceListIndex].status.toString();
    expectedCompletionDropdownValue =
        state.grievanceList[grievanceListIndex].expectedCompletion.toString();
    priorityDropdownValue =
        state.grievanceList[grievanceListIndex].priority.toString();
    grievanceTypeDropdownValue =
        state.grievanceList[grievanceListIndex].grievanceType.toString();
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: BlocBuilder<GrievancesBloc, GrievancesState>(
        builder: (context, state) {
          if (state is UpdatingGrievanceStatusState) {
            return Stack(
              children: [
                grievanceDetails(context),
                const CircularProgressIndicator(
                  color: AppColors.colorPrimary,
                ),
              ],
            );
          }
          if (state is GrievanceUpdatedState) {
            return grievanceDetails(context);
          }
          return grievanceDetails(context);
        },
      ),
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
              horizontal: AppConstants.screenPadding,
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
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/arrowleft.svg',
                              color: AppColors.colorWhite,
                              height: 18.sp,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              LocaleKeys.grievanceDetail_screenTitle.tr(),
                              style: AppStyles.screenTitleStyle,
                            ),
                          ],
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
              padding:
                  EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.grievanceDetail_type.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      iconSize: 24.sp,
                      value: grievanceTypeDropdownValue,
                      decoration: InputDecoration(
                        labelStyle: AppStyles.dropdownTextStyle,
                        border: InputBorder.none,
                      ),
                      items: grievanceTypes
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 1,
                                style: AppStyles.dropdownTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        final grievance =
                            state.grievanceList[grievanceListIndex];
                        grievanceTypeDropdownValue = value.toString();
                        BlocProvider.of<GrievancesBloc>(context).add(
                          UpdateGrievanceEvent(
                            grievanceId: state
                                .grievanceList[grievanceListIndex].grievanceId
                                .toString(),
                            newGrievance: Grievances(
                              grievanceId: grievance.grievanceId,
                              audios: grievance.audios,
                              contactByPhoneEnabled:
                                  grievance.contactByPhoneEnabled,
                              description: grievance.description,
                              expectedCompletion: grievance.expectedCompletion,
                              grievanceType: grievanceTypeDropdownValue,
                              latitude: grievance.latitude,
                              longitude: grievance.longitude,
                              myComments: grievance.myComments,
                              open: grievance.open,
                              photos: grievance.photos,
                              place: grievance.place,
                              priority: grievance.priority,
                              raisedBy: grievance.raisedBy,
                              reporterComments: grievance.reporterComments,
                              status: statusDropdownValue,
                              timeStamp: grievance.timeStamp,
                              videos: grievance.videos,
                              wardNumber: grievance.wardNumber,
                            ),
                          ),
                        );
                      },
                    ),
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
                  PrimaryTextField(
                    onFieldSubmitted: (value) {
                      final grievance = state.grievanceList[grievanceListIndex];

                      BlocProvider.of<GrievancesBloc>(context).add(
                        UpdateGrievanceEvent(
                          grievanceId: state
                              .grievanceList[grievanceListIndex].grievanceId
                              .toString(),
                          newGrievance: Grievances(
                            grievanceId: grievance.grievanceId,
                            audios: grievance.audios,
                            contactByPhoneEnabled:
                                grievance.contactByPhoneEnabled,
                            description: grievance.description,
                            expectedCompletion: grievance.expectedCompletion,
                            grievanceType: grievance.grievanceType,
                            latitude: grievance.latitude,
                            longitude: grievance.longitude,
                            myComments: grievance.myComments,
                            open: grievance.open,
                            photos: grievance.photos,
                            place: grievance.place,
                            priority: grievance.priority,
                            raisedBy: value,
                            reporterComments: grievance.reporterComments,
                            status: grievance.status,
                            timeStamp: grievance.timeStamp,
                            videos: grievance.videos,
                            wardNumber: grievance.wardNumber,
                          ),
                        ),
                      );
                    },
                    title: LocaleKeys.grievanceDetail_reporter.tr(),
                    textEditingController: reporterController,
                    hintText: 'Reporter name',
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    LocaleKeys.grievanceDetail_status.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      iconSize: 24.sp,
                      value: statusDropdownValue,
                      decoration: InputDecoration(
                        labelStyle: AppStyles.dropdownTextStyle,
                        border: InputBorder.none,
                      ),
                      items: statusList
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 1,
                                style: AppStyles.dropdownTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        final grievance =
                            state.grievanceList[grievanceListIndex];
                        statusDropdownValue = value.toString();
                        BlocProvider.of<GrievancesBloc>(context).add(
                          UpdateGrievanceEvent(
                            grievanceId: state
                                .grievanceList[grievanceListIndex].grievanceId
                                .toString(),
                            newGrievance: Grievances(
                              grievanceId: grievance.grievanceId,
                              audios: grievance.audios,
                              contactByPhoneEnabled:
                                  grievance.contactByPhoneEnabled,
                              description: grievance.description,
                              expectedCompletion: grievance.expectedCompletion,
                              grievanceType: grievance.grievanceType,
                              latitude: grievance.latitude,
                              longitude: grievance.longitude,
                              myComments: grievance.myComments,
                              open: grievance.open,
                              photos: grievance.photos,
                              place: grievance.place,
                              priority: grievance.priority,
                              raisedBy: grievance.raisedBy,
                              reporterComments: grievance.reporterComments,
                              status: statusDropdownValue,
                              timeStamp: grievance.timeStamp,
                              videos: grievance.videos,
                              wardNumber: grievance.wardNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    LocaleKeys.grievanceDetail_expectedCompletionIn.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      iconSize: 24.sp,
                      value: expectedCompletionDropdownValue,
                      decoration: InputDecoration(
                        labelStyle: AppStyles.dropdownTextStyle,
                        border: InputBorder.none,
                      ),
                      items: expectedCompletionList
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 1,
                                style: AppStyles.dropdownTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        expectedCompletionDropdownValue = value.toString();
                        final grievance =
                            state.grievanceList[grievanceListIndex];
                        expectedCompletionDropdownValue = value.toString();
                        BlocProvider.of<GrievancesBloc>(context).add(
                          UpdateGrievanceEvent(
                            grievanceId: state
                                .grievanceList[grievanceListIndex].grievanceId
                                .toString(),
                            newGrievance: Grievances(
                              grievanceId: grievance.grievanceId,
                              audios: grievance.audios,
                              contactByPhoneEnabled:
                                  grievance.contactByPhoneEnabled,
                              description: grievance.description,
                              expectedCompletion:
                                  expectedCompletionDropdownValue,
                              grievanceType: grievance.grievanceType,
                              latitude: grievance.latitude,
                              longitude: grievance.longitude,
                              myComments: grievance.myComments,
                              open: grievance.open,
                              photos: grievance.photos,
                              place: grievance.place,
                              priority: grievance.priority,
                              raisedBy: grievance.raisedBy,
                              reporterComments: grievance.reporterComments,
                              status: grievance.status,
                              timeStamp: grievance.timeStamp,
                              videos: grievance.videos,
                              wardNumber: grievance.wardNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    LocaleKeys.grievanceDetail_priority.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      iconSize: 24.sp,
                      value: priorityDropdownValue,
                      decoration: InputDecoration(
                        labelStyle: AppStyles.dropdownTextStyle,
                        border: InputBorder.none,
                      ),
                      items: priorityList
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                maxLines: 1,
                                style: AppStyles.dropdownTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        priorityDropdownValue = value.toString();
                        final grievance =
                            state.grievanceList[grievanceListIndex];
                        BlocProvider.of<GrievancesBloc>(context).add(
                          UpdateGrievanceEvent(
                            grievanceId: state
                                .grievanceList[grievanceListIndex].grievanceId
                                .toString(),
                            newGrievance: Grievances(
                              grievanceId: grievance.grievanceId,
                              audios: grievance.audios,
                              contactByPhoneEnabled:
                                  grievance.contactByPhoneEnabled,
                              description: grievance.description,
                              expectedCompletion: grievance.expectedCompletion,
                              grievanceType: grievance.grievanceType,
                              latitude: grievance.latitude,
                              longitude: grievance.longitude,
                              myComments: grievance.myComments,
                              open: grievance.open,
                              photos: grievance.photos,
                              place: grievance.place,
                              priority: priorityDropdownValue,
                              raisedBy: grievance.raisedBy,
                              reporterComments: grievance.reporterComments,
                              status: grievance.status,
                              timeStamp: grievance.timeStamp,
                              videos: grievance.videos,
                              wardNumber: grievance.wardNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    LocaleKeys.grievanceDetail_photosAndVideos.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
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
                                  LocaleKeys.grievanceDetail_viewAll.tr(),
                                  style: AppStyles.viewAllWhiteTextStyle,
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
                    LocaleKeys.grievanceDetail_voiceAndAudio.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
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
                                  '${LocaleKeys.grievanceDetail_audio.tr()} - ${index + 1}',
                                  style: AppStyles.audioTitleTextStyle,
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
                                    LocaleKeys.grievanceDetail_viewAll.tr(),
                                    style: AppStyles.viewAllWhiteTextStyle,
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
                    LocaleKeys.grievanceDetail_locaiton.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  LocationMapField(
                    markerEnabled: true,
                    gesturesEnabled: false,
                    myLocationEnabled: false,
                    zoomEnabled: false,
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
                    LocaleKeys.grievanceDetail_description.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
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
                      style: AppStyles.descriptiveTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.grievanceDetail_contactByPhoneEnabled.tr(),
                        style: AppStyles.inputAndDisplayTitleStyle,
                      ),
                      const Spacer(),
                      Text(
                        state.grievanceList[grievanceListIndex]
                                    .contactByPhoneEnabled ==
                                true
                            ? 'Yes'
                            : 'No',
                        style: AppStyles.inputAndDisplayTitleStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.grievanceDetail_commentsByReporter.tr(),
                        style: AppStyles.inputAndDisplayTitleStyle,
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
                          LocaleKeys.grievanceDetail_viewAll.tr(),
                          style: AppStyles.inputAndDisplayTitleStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryLight,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                        children: state
                            .grievanceList[grievanceListIndex].reporterComments!
                            .mapIndexed((i, e) {
                      if (i >= 6) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          e.text == ''
                              ? const SizedBox()
                              : TextCommentWidget(
                                  commentList: state
                                      .grievanceList[grievanceListIndex]
                                      .reporterComments as List<dynamic>,
                                  commentListIndex: i,
                                ),
                          e.imageUrl == ''
                              ? const SizedBox()
                              : PhotoCommentWidget(
                                  commentList: state
                                      .grievanceList[grievanceListIndex]
                                      .reporterComments as List<dynamic>,
                                  commentListIndex: i,
                                ),
                          e.videoUrl == ''
                              ? const SizedBox()
                              : VideoCommentWidget(
                                  commentList: state
                                      .grievanceList[grievanceListIndex]
                                      .reporterComments as List<dynamic>,
                                  commentListIndex: i,
                                ),
                          e.audioUrl == ''
                              ? const SizedBox()
                              : AudioCommentWidget(
                                  commentList: state
                                      .grievanceList[grievanceListIndex]
                                      .reporterComments as List<dynamic>,
                                  commentListIndex: i,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          i <
                                  state.grievanceList[grievanceListIndex]
                                          .reporterComments!.length -
                                      1
                              ? const Divider(
                                  color: AppColors.colorGreyLight,
                                )
                              : const SizedBox(),
                        ],
                      );
                    }).toList()),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.grievanceDetail_myComments.tr(),
                        style: AppStyles.inputAndDisplayTitleStyle,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            GrievanceAddComment.routeName,
                            arguments: {
                              "grievanceId": state
                                  .grievanceList[grievanceListIndex]
                                  .grievanceId,
                            },
                          );
                        },
                        child: Text(
                          LocaleKeys.grievanceDetail_addComment.tr(),
                          style: AppStyles.inputAndDisplayTitleStyle,
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
                              LocaleKeys.grievanceDetail_viewAll.tr(),
                              style: AppStyles.inputAndDisplayTitleStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Column(
                            children: state
                                .grievanceList[grievanceListIndex].myComments!
                                .mapIndexed((i, e) {
                          if (i >= 6) {
                            return const SizedBox();
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              e.text == ''
                                  ? const SizedBox()
                                  : TextCommentWidget(
                                      commentList: state
                                          .grievanceList[grievanceListIndex]
                                          .myComments as List<dynamic>,
                                      commentListIndex: i,
                                    ),
                              e.imageUrl == ''
                                  ? const SizedBox()
                                  : PhotoCommentWidget(
                                      commentList: state
                                          .grievanceList[grievanceListIndex]
                                          .myComments as List<dynamic>,
                                      commentListIndex: i,
                                    ),
                              e.videoUrl == ''
                                  ? const SizedBox()
                                  : VideoCommentWidget(
                                      commentList: state
                                          .grievanceList[grievanceListIndex]
                                          .myComments as List<dynamic>,
                                      commentListIndex: i,
                                    ),
                              e.audioUrl == ''
                                  ? const SizedBox()
                                  : AudioCommentWidget(
                                      commentList: state
                                          .grievanceList[grievanceListIndex]
                                          .myComments as List<dynamic>,
                                      commentListIndex: i,
                                    ),
                              SizedBox(
                                height: 10.h,
                              ),
                              i <
                                      state.grievanceList[grievanceListIndex]
                                              .myComments!.length -
                                          1
                                  ? const Divider(
                                      color: AppColors.colorGreyLight,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        }).toList()),
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
                            buttonText:
                                LocaleKeys.grievanceDetail_closeGrievance.tr(),
                            isLoading: true,
                            onTap: () {},
                          );
                        }
                        if (grievanceClosing is ClosingGrievanceFailedState) {
                          return SecondaryButton(
                            buttonText:
                                LocaleKeys.grievanceDetail_closeGrievance.tr(),
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
                          buttonText:
                              LocaleKeys.grievanceDetail_closeGrievance.tr(),
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
