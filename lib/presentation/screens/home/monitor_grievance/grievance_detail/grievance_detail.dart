import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_dialog_button.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_text_field.dart';
import 'package:civic_staff/presentation/widgets/video_thumbnail.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_comments.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_audio.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_photo_video.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/audio_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/photo_comment_widget.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/secondary_button.dart';
import 'package:civic_staff/presentation/widgets/text_comment_widget.dart';
import 'package:video_player/video_player.dart';

class GrievanceDetail extends StatelessWidget {
  static const routeName = '/grievanceDetail';
  GrievanceDetail({
    super.key,
    required this.grievanceId,
  });
  final String grievanceId;
  final Completer<GoogleMapController> _controller = Completer();
  late List<MasterData> statusList;
  // late Map<dynamic, dynamic> grievanceTypesMap;
  late List<MuicipalityGrievances> grievanceTypesList;
  List<Comments>? grievanceComments;
  List<String> expectedCompletionList = ['1 Day', '2 Days', '3 Days'];
  late List<MasterData> priorityList;

  late String statusDropdownValue;
  late String expectedCompletionDropdownValue;
  late String priorityDropdownValue;
  late String grievanceTypeDropdownValue;

  bool showDropdownError = false;
  TextEditingController reporterController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    priorityList = AuthBasedRouting.afterLogin.masterData!
        .where(
            (element) => element.pK == '#PRIORITY#' && element.active == true)
        .toList();
    statusList = AuthBasedRouting.afterLogin.masterData!
        .where((element) =>
            element.pK == '#GRIEVANCESTATUS#' && element.active == true)
        .toList();
    grievanceTypesList = AuthBasedRouting.afterLogin.grievanceTypes!
        .firstWhere((element) =>
            element.municipalityID ==
            AuthBasedRouting.afterLogin.userDetails!.municipalityID)
        .grievances!;

    BlocProvider.of<GrievancesBloc>(context).add(
      GetGrievanceByIdEvent(
        municipalityId:
            AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
        grievanceId: grievanceId,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<GrievancesBloc>(context).add(
            LoadGrievancesEvent(
              staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
              municipalityId:
                  AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
            ),
          );
          return true;
        },
        child: Column(
          children: [
            const GrievanceDetailAppBar(),
            BlocConsumer<GrievancesBloc, GrievancesState>(
              listener: (context, state) {
                if (state is GrievanceTypeUpdatedState) {
                  Navigator.of(context).maybePop();
                }
                if (state is GrievancesLoadedState) {
                  BlocProvider.of<GrievancesBloc>(context)
                      .add(GetGrievanceByIdEvent(
                    municipalityId: AuthBasedRouting
                        .afterLogin.userDetails!.municipalityID!,
                    grievanceId: grievanceId,
                  ));
                }
                if (state is LoadingGrievanceByIdFailedState) {
                  BlocProvider.of<GrievancesBloc>(context)
                      .add(GetGrievanceByIdEvent(
                    municipalityId: AuthBasedRouting
                        .afterLogin.userDetails!.municipalityID!,
                    grievanceId: grievanceId,
                  ));
                }
              },
              builder: (context, state) {
                if (state is UpdatingGrievanceStatusState) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  );
                }
                if (state is LoadingGrievanceByIdState) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  );
                }
                if (state is GrievanceByIdLoadedState) {
                  grievanceComments = state.grievanceDetail.comments;
                  grievanceComments!.sort((a, b) =>
                      DateTime.parse(a.createdDate.toString())
                          .compareTo(DateTime.parse(b.createdDate.toString())));
                  grievanceComments = grievanceComments!.reversed
                      .take(6)
                      .toList()
                      .reversed
                      .toList();
                  return grievanceDetails(context, state);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  grievanceDetails(BuildContext context, GrievanceByIdLoadedState state) {
    reporterController.text = state.grievanceDetail.createdByName.toString();
    statusDropdownValue = state.grievanceDetail.status.toString();
    expectedCompletionDropdownValue =
        state.grievanceDetail.expectedCompletion.toString();
    priorityDropdownValue = state.grievanceDetail.priority.toString();
    grievanceTypeDropdownValue = state.grievanceDetail.grievanceType!;
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
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
                  items: grievanceTypesList
                      .toList()
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item.grievanceType,
                          child: Text(
                            item.grievanceTypeName.toString(),
                            maxLines: 1,
                            style: AppStyles.dropdownTextStyle,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    final grievance = state.grievanceDetail;
                    grievanceTypeDropdownValue = value.toString();
                    BlocProvider.of<GrievancesBloc>(context).add(
                      UpdateGrievanceTypeEvent(
                        grievanceId:
                            state.grievanceDetail.grievanceID.toString(),
                        municipalityId: AuthBasedRouting
                            .afterLogin.userDetails!.municipalityID!,
                        newGrievance: Grievances(
                          grievanceID: grievance.grievanceID,
                          assets: state.grievanceDetail.assets!.toJson(),
                          description: grievance.description,
                          expectedCompletion: expectedCompletionDropdownValue,
                          grievanceType: grievanceTypeDropdownValue,
                          locationLat: grievance.locationLat,
                          locationLong: grievance.locationLong,
                          address: grievance.address,
                          priority: priorityDropdownValue,
                          createdBy: grievance.createdBy,
                          status: statusDropdownValue,
                          wardNumber: grievance.wardNumber,
                          contactNumber: grievance.contactNumber,
                          createdByName: grievance.createdByName,
                          lastModifiedDate: DateTime.now().toString(),
                          location: grievance.location,
                          mobileContactStatus: grievance.mobileContactStatus,
                          municipalityID: grievance.municipalityID,
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
                enabled: false,
                onFieldSubmitted: (value) {},
                title: LocaleKeys.grievanceDetail_reporter.tr(),
                textEditingController: reporterController,
                hintText: 'Reporter name',
              ),
              SizedBox(
                height: 12.h,
              ),
              PrimaryDisplayField(
                title: 'Status',
                value: statusList
                    .firstWhere((element) => element.sK == statusDropdownValue)
                    .name
                    .toString(),
                suffixIcon: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        value: item.sK,
                                        child: Text(
                                          item.name.toString(),
                                          maxLines: 1,
                                          style: AppStyles.dropdownTextStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  statusDropdownValue = value.toString();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            PrimaryTextField(
                              title: 'Comment',
                              hintText: 'The status has been changed.',
                              textEditingController: commentTextController,
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            BlocConsumer<GrievancesBloc, GrievancesState>(
                              listener: (context, state) {
                                if (state
                                    is AddingGrievanceCommentSuccessState) {
                                  Navigator.of(context).pop();
                                }
                              },
                              builder: (context, state) {
                                if (state is GrievanceByIdLoadedState) {
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: PrimaryDialogButton(
                                      buttonText: 'Submit',
                                      isLoading: false,
                                      onTap: () {
                                        BlocProvider.of<GrievancesBloc>(context)
                                            .add(
                                          AddGrievanceCommentEvent(
                                            grievanceId: grievanceId,
                                            staffId: AuthBasedRouting
                                                .afterLogin.userDetails!.staffID
                                                .toString(),
                                            name: AuthBasedRouting.afterLogin
                                                .userDetails!.firstName
                                                .toString(),
                                            assets: const {},
                                            comment: commentTextController
                                                    .text.isEmpty
                                                ? statusDropdownValue == '1'
                                                    ? 'Status of your grievance was updated to "In Progress".'
                                                    : statusDropdownValue == '2'
                                                        ? 'Your grievance was closed.'
                                                        : statusDropdownValue ==
                                                                '3'
                                                            ? 'Status of your grievance was updated to "Hold".'
                                                            : commentTextController
                                                                .text
                                                : commentTextController.text,
                                          ),
                                        );
                                        final grievance = state.grievanceDetail;
                                        BlocProvider.of<GrievancesBloc>(context)
                                            .add(
                                          UpdateGrievanceEvent(
                                            grievanceId: state
                                                .grievanceDetail.grievanceID
                                                .toString(),
                                            municipalityId: AuthBasedRouting
                                                .afterLogin
                                                .userDetails!
                                                .municipalityID!,
                                            newGrievance: Grievances(
                                              grievanceID:
                                                  grievance.grievanceID,
                                              assets: state
                                                  .grievanceDetail.assets!
                                                  .toJson(),
                                              description:
                                                  grievance.description,
                                              expectedCompletion:
                                                  expectedCompletionDropdownValue,
                                              grievanceType:
                                                  grievanceTypeDropdownValue,
                                              locationLat:
                                                  grievance.locationLat,
                                              locationLong:
                                                  grievance.locationLong,
                                              address: grievance.address,
                                              priority: priorityDropdownValue,
                                              createdBy: grievance.createdBy,
                                              status: statusDropdownValue,
                                              wardNumber: grievance.wardNumber,
                                              contactNumber:
                                                  grievance.contactNumber,
                                              createdByName:
                                                  grievance.createdByName,
                                              lastModifiedDate:
                                                  DateTime.now().toString(),
                                              location: grievance.location,
                                              mobileContactStatus:
                                                  grievance.mobileContactStatus,
                                              municipalityID:
                                                  grievance.municipalityID,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                if (state is AddGrievanceCommentEvent) {
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: PrimaryDialogButton(
                                      buttonText: 'Submit',
                                      isLoading: true,
                                      onTap: () {},
                                    ),
                                  );
                                }
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: PrimaryDialogButton(
                                    buttonText: 'Submit',
                                    isLoading: false,
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Change Status',
                    style: TextStyle(
                      color: AppColors.textColorRed,
                      fontSize: 10.sp,
                    ),
                  ),
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
                    final grievance = state.grievanceDetail;
                    expectedCompletionDropdownValue = value.toString();
                    BlocProvider.of<GrievancesBloc>(context).add(
                      UpdateGrievanceEvent(
                        grievanceId:
                            state.grievanceDetail.grievanceID.toString(),
                        municipalityId: AuthBasedRouting
                            .afterLogin.userDetails!.municipalityID!,
                        newGrievance: Grievances(
                          grievanceID: grievance.grievanceID,
                          assets: state.grievanceDetail.assets!.toJson(),
                          description: grievance.description,
                          expectedCompletion: expectedCompletionDropdownValue,
                          grievanceType: grievanceTypeDropdownValue,
                          locationLat: grievance.locationLat,
                          locationLong: grievance.locationLong,
                          address: grievance.address,
                          priority: priorityDropdownValue,
                          createdBy: grievance.createdBy,
                          status: statusDropdownValue,
                          wardNumber: grievance.wardNumber,
                          contactNumber: grievance.contactNumber,
                          createdByName: grievance.createdByName,
                          lastModifiedDate: DateTime.now().toString(),
                          location: grievance.location,
                          mobileContactStatus: grievance.mobileContactStatus,
                          municipalityID: grievance.municipalityID,
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
                          value: item.sK,
                          child: Text(
                            item.name.toString(),
                            maxLines: 1,
                            style: AppStyles.dropdownTextStyle,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    priorityDropdownValue = value.toString();
                    final grievance = state.grievanceDetail;
                    BlocProvider.of<GrievancesBloc>(context).add(
                      UpdateGrievanceEvent(
                        grievanceId:
                            state.grievanceDetail.grievanceID.toString(),
                        municipalityId: AuthBasedRouting
                            .afterLogin.userDetails!.municipalityID!,
                        newGrievance: Grievances(
                          grievanceID: grievance.grievanceID,
                          assets: state.grievanceDetail.assets!.toJson(),
                          description: grievance.description,
                          expectedCompletion: expectedCompletionDropdownValue,
                          grievanceType: grievanceTypeDropdownValue,
                          locationLat: grievance.locationLat,
                          locationLong: grievance.locationLong,
                          address: grievance.address,
                          priority: priorityDropdownValue,
                          createdBy: grievance.createdBy,
                          status: statusDropdownValue,
                          wardNumber: grievance.wardNumber,
                          contactNumber: grievance.contactNumber,
                          createdByName: grievance.createdByName,
                          lastModifiedDate: DateTime.now().toString(),
                          location: grievance.location,
                          mobileContactStatus: grievance.mobileContactStatus,
                          municipalityID: grievance.municipalityID,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              state.grievanceDetail.assets!.audio == null &&
                      state.grievanceDetail.assets!.video == null &&
                      state.grievanceDetail.assets!.image == null
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                itemCount: state
                                        .grievanceDetail.assets!.image!.length +
                                    state.grievanceDetail.assets!.video!.length,
                                itemBuilder: (context, index) {
                                  if (index <
                                      state.grievanceDetail.assets!.image!
                                          .length) {
                                    return Container(
                                      clipBehavior: Clip.antiAlias,
                                      height: 70.h,
                                      width: 70.h,
                                      margin: EdgeInsets.only(right: 12.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        color: AppColors.colorPrimaryLight,
                                      ),
                                      child: Image.network(
                                        state.grievanceDetail.assets!
                                            .image![index],
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          return const Center(
                                            child: Icon(Icons.image),
                                          );
                                        },
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
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: GrievanceDetailVideoWidget(
                                        url: state
                                                .grievanceDetail.assets!.video![
                                            index -
                                                state.grievanceDetail.assets!
                                                    .image!.length],
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
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          GrievancePhotoVideo.routeName,
                                          arguments: {
                                            "index": 1,
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
                      ],
                    ),
              state.grievanceDetail.assets!.audio == null ||
                      state.grievanceDetail.assets!.audio!.isEmpty
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                itemCount:
                                    state.grievanceDetail.assets!.audio!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        height: 70.h,
                                        width: 70.h,
                                        margin: EdgeInsets.only(right: 12.w),
                                        padding: EdgeInsets.all(20.sp),
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            GrievanceAudio.routeName,
                                            arguments: {
                                              "index": 1,
                                              "state": state,
                                            },
                                          );
                                        },
                                        child: Text(
                                          LocaleKeys.grievanceDetail_viewAll
                                              .tr(),
                                          style:
                                              AppStyles.viewAllWhiteTextStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  state.grievanceDetail.locationLat.toString(),
                ),
                longitude: double.parse(
                  state.grievanceDetail.locationLong.toString(),
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
                  state.grievanceDetail.description.toString(),
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
                    state.grievanceDetail.mobileContactStatus == true
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
                    'Comments',
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    '(Latest 6)',
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AllComments.routeName,
                        arguments: {
                          'grievanceId': state.grievanceDetail.grievanceID,
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
                child: grievanceComments!.isEmpty
                    ? const Center(
                        child: Text('No Comments Yet!'),
                      )
                    : Column(
                        children: grievanceComments!.mapIndexed((i, e) {
                        if (i >= 6) {
                          return const SizedBox();
                        }
                        return Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            e.comment == '' ||
                                    e.comment == null ||
                                    e.comment!.isEmpty
                                ? const SizedBox()
                                : TextCommentWidget(
                                    // commentList: [],
                                    commentList:
                                        grievanceComments as List<Comments>,
                                    commentListIndex: i,
                                  ),
                            e.assets == null
                                ? const SizedBox()
                                : e.assets!.image == null ||
                                        e.assets!.image == [] ||
                                        e.assets!.image!.isEmpty
                                    ? const SizedBox()
                                    : PhotoCommentWidget(
                                        // commentList: [],
                                        commentList:
                                            grievanceComments as List<Comments>,
                                        commentListIndex: i,
                                      ),
                            e.assets == null
                                ? const SizedBox()
                                : e.assets!.video == null ||
                                        e.assets!.video == [] ||
                                        e.assets!.video!.isEmpty
                                    ? const SizedBox()
                                    : Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenVideoPlayer(
                                                  url: e.assets!.video![0],
                                                  file: null,
                                                ),
                                              ));
                                            },
                                            child: Align(
                                              alignment: e.commentedBy ==
                                                      AuthBasedRouting
                                                          .afterLogin
                                                          .userDetails!
                                                          .staffID
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
                                                      color: AppColors
                                                          .cardShadowColor,
                                                    ),
                                                    BoxShadow(
                                                      blurRadius: 2,
                                                      offset: Offset(-1, -1),
                                                      color:
                                                          AppColors.colorWhite,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: AppColors
                                                      .colorPrimaryLight,
                                                ),
                                                child: VideoThumbnail(
                                                  url: e.assets!.video![0],
                                                  commentList:
                                                      grievanceComments,
                                                  commentListIndex: i,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                            // : VideoCommentWidget(
                            //     // commentList: [],
                            //     commentList:
                            //         grievanceComments as List<Comments>,
                            //     commentListIndex: i,
                            //   ),
                            e.assets == null
                                ? const SizedBox()
                                : e.assets!.audio == null ||
                                        e.assets!.video == [] ||
                                        e.assets!.audio!.isEmpty
                                    ? const SizedBox()
                                    : AudioCommentWidget(
                                        // commentList: [],
                                        commentList:
                                            grievanceComments as List<Comments>,
                                        commentListIndex: i,
                                      ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // i <
                            //         state.grievanceDetail
                            //                 .comments!.length -
                            //             1
                            //     ? const Divider(
                            //         color: AppColors.colorGreyLight,
                            //       )
                            //     : const SizedBox(),
                          ],
                        );
                      }).toList()),
              ),
              SizedBox(
                height: 30.h,
              ),
              statusDropdownValue == '2'
                  ? const SizedBox()
                  : Align(
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
                              buttonText: LocaleKeys
                                  .grievanceDetail_closeGrievance
                                  .tr(),
                              isLoading: true,
                              onTap: () {},
                            );
                          }
                          if (grievanceClosing is ClosingGrievanceFailedState) {
                            return SecondaryButton(
                              buttonText: LocaleKeys
                                  .grievanceDetail_closeGrievance
                                  .tr(),
                              isLoading: false,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Close Grievance',
                                          style: AppStyles
                                              .inputAndDisplayTitleStyle,
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        PrimaryTextField(
                                          title: 'Comment',
                                          hintText:
                                              'Your grievance was closed.',
                                          textEditingController:
                                              commentTextController,
                                        ),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        BlocConsumer<GrievancesBloc,
                                            GrievancesState>(
                                          listener: (context, state) {
                                            if (state
                                                is AddingGrievanceCommentSuccessState) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          builder: (context, state) {
                                            if (state
                                                is GrievanceByIdLoadedState) {
                                              return Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: PrimaryDialogButton(
                                                  buttonText: 'Submit',
                                                  isLoading: false,
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                GrievancesBloc>(
                                                            context)
                                                        .add(
                                                      AddGrievanceCommentEvent(
                                                        grievanceId:
                                                            grievanceId,
                                                        staffId:
                                                            AuthBasedRouting
                                                                .afterLogin
                                                                .userDetails!
                                                                .staffID
                                                                .toString(),
                                                        name: AuthBasedRouting
                                                            .afterLogin
                                                            .userDetails!
                                                            .firstName
                                                            .toString(),
                                                        assets: const {},
                                                        comment: commentTextController
                                                                .text.isEmpty
                                                            ? 'Your grievance is closed.'
                                                            : commentTextController
                                                                .text,
                                                      ),
                                                    );
                                                    final grievance =
                                                        state.grievanceDetail;
                                                    BlocProvider.of<
                                                                GrievancesBloc>(
                                                            context)
                                                        .add(
                                                      UpdateGrievanceEvent(
                                                        grievanceId: state
                                                            .grievanceDetail
                                                            .grievanceID
                                                            .toString(),
                                                        municipalityId:
                                                            AuthBasedRouting
                                                                .afterLogin
                                                                .userDetails!
                                                                .municipalityID!,
                                                        newGrievance:
                                                            Grievances(
                                                          grievanceID: grievance
                                                              .grievanceID,
                                                          assets: state
                                                              .grievanceDetail
                                                              .assets!
                                                              .toJson(),
                                                          description: grievance
                                                              .description,
                                                          expectedCompletion:
                                                              expectedCompletionDropdownValue,
                                                          grievanceType:
                                                              grievanceTypeDropdownValue,
                                                          locationLat: grievance
                                                              .locationLat,
                                                          locationLong:
                                                              grievance
                                                                  .locationLong,
                                                          address:
                                                              grievance.address,
                                                          priority:
                                                              priorityDropdownValue,
                                                          createdBy: grievance
                                                              .createdBy,
                                                          status: '2',
                                                          wardNumber: grievance
                                                              .wardNumber,
                                                          contactNumber:
                                                              grievance
                                                                  .contactNumber,
                                                          createdByName:
                                                              grievance
                                                                  .createdByName,
                                                          lastModifiedDate:
                                                              DateTime.now()
                                                                  .toString(),
                                                          location: grievance
                                                              .location,
                                                          mobileContactStatus:
                                                              grievance
                                                                  .mobileContactStatus,
                                                          municipalityID:
                                                              grievance
                                                                  .municipalityID,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                            if (state
                                                is AddGrievanceCommentEvent) {
                                              return Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: PrimaryDialogButton(
                                                  buttonText: 'Submit',
                                                  isLoading: true,
                                                  onTap: () {},
                                                ),
                                              );
                                            }
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: PrimaryDialogButton(
                                                buttonText: 'Submit',
                                                isLoading: false,
                                                onTap: () {},
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                // BlocProvider.of<GrievancesBloc>(context).add(
                                //   CloseGrievanceEvent(
                                //     grievanceId:
                                //         state.grievanceDetail.grievanceID.toString(),
                                //   ),
                                // );
                              },
                            );
                          }
                          return SecondaryButton(
                            buttonText:
                                LocaleKeys.grievanceDetail_closeGrievance.tr(),
                            isLoading: false,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   'Closing comment',
                                      //   style: AppStyles.inputAndDisplayTitleStyle,
                                      // ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      PrimaryTextField(
                                        title: 'Closing message',
                                        hintText: 'Your grievance is closed.',
                                        textEditingController:
                                            commentTextController,
                                      ),
                                      SizedBox(
                                        height: 24.h,
                                      ),
                                      BlocConsumer<GrievancesBloc,
                                          GrievancesState>(
                                        listener: (context, state) {
                                          if (state
                                              is AddingGrievanceCommentSuccessState) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state
                                              is GrievanceByIdLoadedState) {
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: PrimaryDialogButton(
                                                buttonText: 'Submit',
                                                isLoading: false,
                                                onTap: () {
                                                  BlocProvider.of<
                                                              GrievancesBloc>(
                                                          context)
                                                      .add(
                                                    AddGrievanceCommentEvent(
                                                      grievanceId: grievanceId,
                                                      staffId: AuthBasedRouting
                                                          .afterLogin
                                                          .userDetails!
                                                          .staffID
                                                          .toString(),
                                                      name: AuthBasedRouting
                                                          .afterLogin
                                                          .userDetails!
                                                          .firstName
                                                          .toString(),
                                                      assets: const {},
                                                      comment: commentTextController
                                                              .text.isEmpty
                                                          ? 'Your grievance is closed.'
                                                          : commentTextController
                                                              .text,
                                                    ),
                                                  );
                                                  final grievance =
                                                      state.grievanceDetail;
                                                  BlocProvider.of<
                                                              GrievancesBloc>(
                                                          context)
                                                      .add(
                                                    UpdateGrievanceEvent(
                                                      grievanceId: state
                                                          .grievanceDetail
                                                          .grievanceID
                                                          .toString(),
                                                      municipalityId:
                                                          AuthBasedRouting
                                                              .afterLogin
                                                              .userDetails!
                                                              .municipalityID!,
                                                      newGrievance: Grievances(
                                                        grievanceID: grievance
                                                            .grievanceID,
                                                        assets: state
                                                            .grievanceDetail
                                                            .assets!
                                                            .toJson(),
                                                        description: grievance
                                                            .description,
                                                        expectedCompletion:
                                                            expectedCompletionDropdownValue,
                                                        grievanceType:
                                                            grievanceTypeDropdownValue,
                                                        locationLat: grievance
                                                            .locationLat,
                                                        locationLong: grievance
                                                            .locationLong,
                                                        address:
                                                            grievance.address,
                                                        priority:
                                                            priorityDropdownValue,
                                                        createdBy:
                                                            grievance.createdBy,
                                                        status: '2',
                                                        wardNumber: grievance
                                                            .wardNumber,
                                                        contactNumber: grievance
                                                            .contactNumber,
                                                        createdByName: grievance
                                                            .createdByName,
                                                        lastModifiedDate:
                                                            DateTime.now()
                                                                .toString(),
                                                        location:
                                                            grievance.location,
                                                        mobileContactStatus:
                                                            grievance
                                                                .mobileContactStatus,
                                                        municipalityID:
                                                            grievance
                                                                .municipalityID,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                          if (state
                                              is AddGrievanceCommentEvent) {
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: PrimaryDialogButton(
                                                buttonText: 'Submit',
                                                isLoading: true,
                                                onTap: () {},
                                              ),
                                            );
                                          }
                                          return Align(
                                            alignment: Alignment.bottomRight,
                                            child: PrimaryDialogButton(
                                              buttonText: 'Submit',
                                              isLoading: false,
                                              onTap: () {},
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              // BlocProvider.of<GrievancesBloc>(context).add(
                              //   CloseGrievanceEvent(
                              //     grievanceId:
                              //         state.grievanceDetail.grievanceID.toString(),
                              //   ),
                              // );
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
    );
  }
}

class GrievanceDetailVideoWidget extends StatefulWidget {
  final String url;
  const GrievanceDetailVideoWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<GrievanceDetailVideoWidget> createState() =>
      _GrievanceDetailVideoWidgetState();
}

class _GrievanceDetailVideoWidgetState
    extends State<GrievanceDetailVideoWidget> {
  late VideoPlayerController _controller;

  late ChewieController _chewieController;
  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.url,
    )..initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      allowMuting: true,
      looping: false,
      showControls: false,
      aspectRatio: 1,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        allowMuting: true,
        looping: false,
        showControls: false,
        aspectRatio: 1,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
        ],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

class GrievanceDetailAppBar extends StatelessWidget {
  const GrievanceDetailAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryTopShape(
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
                    onTap: () {
                      BlocProvider.of<GrievancesBloc>(context).add(
                        LoadGrievancesEvent(
                          staffId:
                              AuthBasedRouting.afterLogin.userDetails!.staffID!,
                          municipalityId: AuthBasedRouting
                              .afterLogin.userDetails!.municipalityID!,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.sp),
                      color: Colors.transparent,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
