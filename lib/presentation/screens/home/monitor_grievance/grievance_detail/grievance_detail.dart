import 'dart:async';
import 'dart:developer';

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
import 'package:geolocator/geolocator.dart';
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

import '../../../../../logic/cubits/current_location/current_location_cubit.dart';

class GrievanceDetail extends StatefulWidget {
  static const routeName = '/grievanceDetail';
  GrievanceDetail({
    super.key,
    required this.grievanceId,
  });
  final String grievanceId;

  @override
  State<GrievanceDetail> createState() => _GrievanceDetailState();
}

class _GrievanceDetailState extends State<GrievanceDetail> {
  final Completer<GoogleMapController> _controller = Completer();

  late List<MasterData> statusList;

  // late Map<dynamic, dynamic> grievanceTypesMap;
  late List<MuicipalityGrievances> grievanceTypesList;

  List<Comments>? grievanceComments;

  List<String> expectedCompletionList = ['1 Day', '2 Days', '3 Days'];

  late List<MasterData> priorityList;

  double? latitude;

  double? longitude;

  late String statusDropdownValue;

  late String expectedCompletionDropdownValue;

  late String priorityDropdownValue;

  late String grievanceTypeDropdownValue;

  bool showDropdownError = false;

  TextEditingController reporterController = TextEditingController();

  TextEditingController commentTextController = TextEditingController();

  final Map<String, String> grievanceTypesMap = {
    "garb": LocaleKeys.grievanceDetail_garb.tr(),
    "road": LocaleKeys.grievanceDetail_road.tr(),
    "light": LocaleKeys.grievanceDetail_light.tr(),
    "cert": LocaleKeys.grievanceDetail_cert.tr(),
    "house": LocaleKeys.grievanceDetail_house.tr(),
    "water": LocaleKeys.grievanceDetail_water.tr(),
    "elect": LocaleKeys.grievanceDetail_elect.tr(),
    "other": LocaleKeys.grievanceDetail_otherGrievanceType.tr(),
  };

  final Map<String, String> statusTypesMap = {
    "in-progress": LocaleKeys.grievanceDetail_inProgress.tr(),
    "hold": LocaleKeys.grievanceDetail_hold.tr(),
    "closed": LocaleKeys.grievanceDetail_closed.tr(),
  };

  final Map<String, String> expectedCompletionTypesMap = {
    "1 Day": LocaleKeys.grievanceDetail_expectedCompletionIn1Day.tr(),
    "2 Days": LocaleKeys.grievanceDetail_expectedCompletionIn2Days.tr(),
    "3 Days": LocaleKeys.grievanceDetail_expectedCompletionIn3Days.tr(),
  };

  final Map<String, String> priorityTypesMap = {
    "1": LocaleKeys.grievanceDetail_priorityImmidiate.tr(),
    "2": LocaleKeys.grievanceDetail_priority1WorkingDay.tr(),
    "3": LocaleKeys.grievanceDetail_priority1Week.tr(),
    "4": LocaleKeys.grievanceDetail_priority1Month.tr(),
    "5": LocaleKeys.grievanceDetail_priorityDummy.tr(),
  };

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
        grievanceId: widget.grievanceId,
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
                    grievanceId: widget.grievanceId,
                  ));
                }
                if (state is LoadingGrievanceByIdFailedState) {
                  BlocProvider.of<GrievancesBloc>(context)
                      .add(GetGrievanceByIdEvent(
                    municipalityId: AuthBasedRouting
                        .afterLogin.userDetails!.municipalityID!,
                    grievanceId: widget.grievanceId,
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
                  // BlocListener<CurrentLocationCubit, CurrentLocationState>(
                  //   listener: (context, locationState) {
                  //     if (locationState is CurrentLocationLoaded) {
                  //       latitude = locationState.latitude;
                  //       longitude = locationState.longitude;
                  //       log("Current Location: ${latitude}, ${longitude}");
                  //     }
                  //   },
                  // );
                  grievanceComments = state.grievanceDetail.comments;
                  grievanceComments!.sort((a, b) =>
                      DateTime.parse(a.createdDate.toString())
                          .compareTo(DateTime.parse(b.createdDate.toString())));
                  grievanceComments = grievanceComments!.reversed
                      .take(6)
                      .toList()
                      .reversed
                      .toList();
                  log('Images: ${state.grievanceDetail.assets!.image!.length}');
                  log('Videos: ${state.grievanceDetail.assets!.video!.length}');
                  state.grievanceDetail.assets!.video!.map((e) => log(e));
                  state.grievanceDetail.assets!.image!.map((e) => log(e));
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
                          // value: grievanceTypesMap[
                          //     item.grievanceType!.toLowerCase()],
                          value: item.grievanceType,
                          child: Text(
                            grievanceTypesMap.containsKey(
                                    item.grievanceType!.toLowerCase())
                                ? grievanceTypesMap[
                                    item.grievanceType!.toLowerCase()]!
                                : item.grievanceTypeName.toString(),
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
                hintText: '',
              ),
              SizedBox(
                height: 12.h,
              ),
              PrimaryDisplayField(
                title: LocaleKeys.grievanceDetail_status.tr(),
                value: statusTypesMap.containsKey(statusList
                        .firstWhere(
                            (element) => element.sK == statusDropdownValue)
                        .name!
                        .toLowerCase()
                        .toString())
                    ? statusTypesMap[statusList
                        .firstWhere(
                            (element) => element.sK == statusDropdownValue)
                        .name!
                        .toLowerCase()
                        .toString()]!
                    : statusList
                        .firstWhere(
                            (element) => element.sK == statusDropdownValue)
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
                                          statusTypesMap.containsKey(item.name!
                                                  .toLowerCase()
                                                  .toString())
                                              ? statusTypesMap[item.name!
                                                  .toLowerCase()
                                                  .toString()]!
                                              : item.name!
                                                  .toLowerCase()
                                                  .toString(),
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
                              title: LocaleKeys.grievanceDetail_comment.tr(),
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
                                      buttonText: LocaleKeys
                                          .grievanceDetail_submitCommentButton
                                          .tr(),
                                      isLoading: false,
                                      onTap: () {
                                        BlocProvider.of<GrievancesBloc>(context)
                                            .add(
                                          AddGrievanceCommentEvent(
                                            grievanceId: widget.grievanceId,
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
                                      buttonText: LocaleKeys
                                          .grievanceDetail_submitCommentButton
                                          .tr(),
                                      isLoading: true,
                                      onTap: () {},
                                    ),
                                  );
                                }
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: PrimaryDialogButton(
                                    buttonText: LocaleKeys
                                        .grievanceDetail_submitCommentButton
                                        .tr(),
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
                    LocaleKeys.grievanceDetail_changeStatus.tr(),
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
                            expectedCompletionTypesMap[item]!,
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
                            priorityTypesMap.containsKey(item.sK)
                                ? priorityTypesMap[item.sK]!
                                : item.name.toString(),
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
              state.grievanceDetail.assets!.video == null ||
                      state.grievanceDetail.assets!.image!.isEmpty &&
                          state.grievanceDetail.assets!.image == null ||
                      state.grievanceDetail.assets!.video!.isEmpty
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
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return const Icon(Icons.error);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.grievanceDetail_contactByPhoneEnabled.tr(),
                      style: AppStyles.inputAndDisplayTitleStyle,
                    ),
                  ),
                  Text(
                    state.grievanceDetail.mobileContactStatus == true
                        ? LocaleKeys.grievanceDetail_yes.tr()
                        : LocaleKeys.grievanceDetail_no.tr(),
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
                    LocaleKeys.grievanceDetail_comments.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    '(${LocaleKeys.grievanceDetail_latest6Comments.tr()})',
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  const Spacer(),
                  Expanded(
                    child: TextButton(
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
                    ? Center(
                        child: Text(
                            LocaleKeys.grievanceDetail_noCommentsMessage.tr()),
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
                                          LocaleKeys
                                              .grievanceDetail_closeGrievance
                                              .tr(),
                                          style: AppStyles
                                              .inputAndDisplayTitleStyle,
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        PrimaryTextField(
                                          title: LocaleKeys
                                              .grievanceDetail_comment
                                              .tr(),
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
                                                  buttonText: LocaleKeys
                                                      .grievanceDetail_submitCommentButton
                                                      .tr(),
                                                  isLoading: false,
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                GrievancesBloc>(
                                                            context)
                                                        .add(
                                                      AddGrievanceCommentEvent(
                                                        grievanceId:
                                                            widget.grievanceId,
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
                                                  buttonText: LocaleKeys
                                                      .grievanceDetail_submitCommentButton
                                                      .tr(),
                                                  isLoading: true,
                                                  onTap: () {},
                                                ),
                                              );
                                            }
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: PrimaryDialogButton(
                                                buttonText: LocaleKeys
                                                    .grievanceDetail_submitCommentButton
                                                    .tr(),
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
                            );
                          }
                          return SecondaryButton(
                            buttonText:
                                LocaleKeys.grievanceDetail_closeGrievance.tr(),
                            isLoading: false,
                            onTap: () async {
                              Position position =
                                  await Geolocator.getCurrentPosition();
                              log("Position is: ${position.latitude}, ${position.longitude}");
                              double distanceInMeters =
                                  Geolocator.distanceBetween(
                                      position.latitude,
                                      position.longitude,
                                      double.parse(state
                                          .grievanceDetail.locationLat
                                          .toString()),
                                      double.parse(state
                                          .grievanceDetail.locationLong
                                          .toString()));
                              log(distanceInMeters.toString());
                              if (state.grievanceDetail.createdBy == "SYSTEM") {
                                if (distanceInMeters <= 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          PrimaryTextField(
                                            title: LocaleKeys
                                                .grievanceDetail_closingMessage
                                                .tr(),
                                            hintText:
                                                'Your grievance is closed.',
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
                                                    buttonText: LocaleKeys
                                                        .grievanceDetail_submitCommentButton
                                                        .tr(),
                                                    isLoading: false,
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  GrievancesBloc>(
                                                              context)
                                                          .add(
                                                        AddGrievanceCommentEvent(
                                                          grievanceId: widget
                                                              .grievanceId,
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
                                                            grievanceID:
                                                                grievance
                                                                    .grievanceID,
                                                            assets: state
                                                                .grievanceDetail
                                                                .assets!
                                                                .toJson(),
                                                            description:
                                                                grievance
                                                                    .description,
                                                            expectedCompletion:
                                                                expectedCompletionDropdownValue,
                                                            grievanceType:
                                                                grievanceTypeDropdownValue,
                                                            locationLat:
                                                                grievance
                                                                    .locationLat,
                                                            locationLong:
                                                                grievance
                                                                    .locationLong,
                                                            address: grievance
                                                                .address,
                                                            priority:
                                                                priorityDropdownValue,
                                                            createdBy: grievance
                                                                .createdBy,
                                                            status: '2',
                                                            wardNumber:
                                                                grievance
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
                                                    buttonText: LocaleKeys
                                                        .grievanceDetail_submitCommentButton
                                                        .tr(),
                                                    isLoading: true,
                                                    onTap: () {},
                                                  ),
                                                );
                                              }
                                              return Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: PrimaryDialogButton(
                                                  buttonText: LocaleKeys
                                                      .grievanceDetail_submitCommentButton
                                                      .tr(),
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
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                                Text(
                                                  "You should be near this site to close this grievance!",
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(height: 12.h),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: PrimaryDialogButton(
                                                    buttonText: "OK",
                                                    isLoading: false,
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        PrimaryTextField(
                                          title: LocaleKeys
                                              .grievanceDetail_closingMessage
                                              .tr(),
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
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: PrimaryDialogButton(
                                                  buttonText: LocaleKeys
                                                      .grievanceDetail_submitCommentButton
                                                      .tr(),
                                                  isLoading: false,
                                                  onTap: () {
                                                    BlocProvider.of<
                                                                GrievancesBloc>(
                                                            context)
                                                        .add(
                                                      AddGrievanceCommentEvent(
                                                        grievanceId:
                                                            widget.grievanceId,
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
                                                  buttonText: LocaleKeys
                                                      .grievanceDetail_submitCommentButton
                                                      .tr(),
                                                  isLoading: true,
                                                  onTap: () {},
                                                ),
                                              );
                                            }
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: PrimaryDialogButton(
                                                buttonText: LocaleKeys
                                                    .grievanceDetail_submitCommentButton
                                                    .tr(),
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
                              }
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
