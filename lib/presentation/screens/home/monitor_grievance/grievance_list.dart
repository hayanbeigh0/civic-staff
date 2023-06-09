import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_map.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/date_formatter.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class GrievanceList extends StatelessWidget {
  static const routeName = '/grievanceList';
  GrievanceList({super.key});
  final TextEditingController _searchController = TextEditingController();
  GlobalKey roadmaintainance = GlobalKey();
  GlobalKey streetlighting = GlobalKey();
  GlobalKey watersupplyanddrainage = GlobalKey();
  GlobalKey garbagecollection = GlobalKey();
  GlobalKey certificaterequest = GlobalKey();
  final Map<String, String> svgList = {
    "road": 'assets/svg/roadmaintainance.svg',
    "light": 'assets/svg/streetlighting.svg',
    "water": 'assets/svg/watersupplyanddrainage.svg',
    "garb": 'assets/svg/garbagecollection.svg',
    "cert": 'assets/svg/certificaterequest.svg',
    "house": 'assets/svg/houseplanapproval.svg',
    "other": 'assets/svg/complaint.svg',
    "elect": 'assets/svg/noelectricity.svg',
  };
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
  bool openGrievancesOnly = true;
  late List<MuicipalityGrievances> grievanceTypesList;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GrievancesBloc>(context).add(
      LoadGrievancesEvent(
        staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
        municipalityId:
            AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
      ),
    );
    grievanceTypesList = AuthBasedRouting.afterLogin.grievanceTypes!
        .firstWhere((element) =>
            element.municipalityID ==
            AuthBasedRouting.afterLogin.userDetails!.municipalityID)
        .grievances!;
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: Column(
        children: [
          PrimaryTopShape(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
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
                                  LocaleKeys.grievancesScreen_screenTitle.tr(),
                                  style: AppStyles.screenTitleStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<GrievancesBloc, GrievancesState>(
                          builder: (context, state) {
                            if (state is GrievancesLoadedState) {
                              return state.grievanceList.isEmpty
                                  ? TextButton(
                                      onPressed: null,
                                      child: Text(
                                        LocaleKeys.grievancesScreen_viewMap
                                            .tr(),
                                        style: AppStyles.appBarActionsTextStyle
                                            .copyWith(
                                          color:
                                              AppColors.colorDisabledTextField,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pushNamed(
                                        GrievanceMap.routeName,
                                      ),
                                      child: Text(
                                        LocaleKeys.grievancesScreen_viewMap
                                            .tr(),
                                        style: AppStyles.appBarActionsTextStyle,
                                      ),
                                    );
                            }
                            return TextButton(
                              onPressed: null,
                              child: Text(
                                LocaleKeys.grievancesScreen_viewMap.tr(),
                                style:
                                    AppStyles.appBarActionsTextStyle.copyWith(
                                  color: AppColors.colorDisabledTextField,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.colorPrimaryExtraLight,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 10.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide.none,
                      ),
                      hintText:
                          LocaleKeys.grievancesScreen_grievanceSearchHint.tr(),
                      hintStyle: AppStyles.searchHintStyle,
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.sp,
                          horizontal: 20.sp,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/searchfieldsuffix.svg',
                          fit: BoxFit.contain,
                          width: 20.sp,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return BlocProvider.of<GrievancesBloc>(context).add(
                          LoadGrievancesEvent(
                            staffId: AuthBasedRouting
                                .afterLogin.userDetails!.staffID!,
                            municipalityId: AuthBasedRouting
                                .afterLogin.userDetails!.municipalityID!,
                          ),
                        );
                      }
                      if (value.isNotEmpty) {
                        return BlocProvider.of<GrievancesBloc>(context).add(
                          SearchGrievanceByReporterNameEvent(
                            reporterName: value,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 75.h,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.grievancesScreen_openGrievancesOnly.tr(),
                            style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontFamily: 'LexendDeca',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const ShowOnlyOpenSwitch(),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.grievancesScreen_resultsOrderedBy.tr(),
                            style: AppStyles.listOrderedByTextStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                      Divider(
                        height: 10.h,
                        color: AppColors.colorGreyLight,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<GrievancesBloc, GrievancesState>(
                    builder: (context, state) {
                      if (state is GrievancesLoadingState) {
                        return Shimmer.fromColors(
                          baseColor: AppColors.colorPrimary200,
                          highlightColor: AppColors.colorPrimaryExtraLight,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            itemCount: 8,
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.screenPadding,
                                vertical: 15.h,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: AppConstants.screenPadding,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimaryLight,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                    color: AppColors.cardShadowColor,
                                  ),
                                  BoxShadow(
                                    offset: Offset(-5, -5),
                                    blurRadius: 10,
                                    color: AppColors.colorWhite,
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SvgPicture.asset('assets/svg/complaint.svg'),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: AppStyles.cardTextStyle,
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: AppStyles.cardTextStyle,
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: AppStyles.cardTextStyle,
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: AppStyles.cardTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(18.w),
                                        decoration: const BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(5, 5),
                                              blurRadius: 10,
                                              color: AppColors.cardShadowColor,
                                            ),
                                            BoxShadow(
                                              offset: Offset(-5, -5),
                                              blurRadius: 10,
                                              color: AppColors.colorWhite,
                                            ),
                                          ],
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/arrowright.svg',
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      if (state is GrievancesLoadedState) {
                        if (state.grievanceList.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              return BlocProvider.of<GrievancesBloc>(context)
                                  .add(
                                LoadGrievancesEvent(
                                  staffId: AuthBasedRouting
                                      .afterLogin.userDetails!.staffID!,
                                  municipalityId: AuthBasedRouting
                                      .afterLogin.userDetails!.municipalityID!,
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                ListView(),
                                Center(
                                  child: Text(LocaleKeys
                                      .grievancesScreen_noGrievanceErrorMessage
                                      .tr()),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            color: AppColors.colorPrimary,
                            onRefresh: () async {
                              BlocProvider.of<GrievancesBloc>(context).add(
                                LoadGrievancesEvent(
                                  staffId: AuthBasedRouting
                                      .afterLogin.userDetails!.staffID!,
                                  municipalityId: AuthBasedRouting
                                      .afterLogin.userDetails!.municipalityID!,
                                ),
                              );
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              itemCount: state.grievanceList.isEmpty
                                  ? 8
                                  : state.grievanceList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  // borderRadius: BorderRadius.circular(20.r),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        GrievanceDetail.routeName,
                                        arguments: {
                                          "state": state,
                                          "index": index,
                                          "grievanceId": state
                                              .grievanceList[index].grievanceID
                                        });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 15.h,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: AppConstants.screenPadding,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.colorPrimaryLight,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(5, 5),
                                          blurRadius: 10,
                                          color: AppColors.cardShadowColor,
                                        ),
                                        BoxShadow(
                                          offset: Offset(-5, -5),
                                          blurRadius: 10,
                                          color: AppColors.colorWhite,
                                        ),
                                      ],
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        SvgPicture.asset(
                                          svgList[state.grievanceList[index]
                                                  .grievanceType!
                                                  .replaceAll(' ', '')
                                                  .toString()
                                                  .toLowerCase()]
                                              .toString(),
                                          width: 60.w,
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                grievanceTypesMap.containsKey(
                                                        state
                                                            .grievanceList[
                                                                index]
                                                            .grievanceType!
                                                            .toLowerCase())
                                                    ? grievanceTypesMap[state
                                                            .grievanceList[
                                                                index]
                                                            .grievanceType!
                                                            .toLowerCase()]
                                                        .toString()
                                                    : grievanceTypesList
                                                        .firstWhere((element) =>
                                                            element
                                                                .grievanceType!
                                                                .toLowerCase() ==
                                                            state
                                                                .grievanceList[
                                                                    index]
                                                                .grievanceType!
                                                                .toLowerCase())
                                                        .grievanceTypeName
                                                        .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppStyles.cardTextStyle,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Transform.translate(
                                                    offset: Offset(0, 2.h),
                                                    child: Icon(
                                                      Icons.location_pin,
                                                      size: 16.sp,
                                                      color: AppColors
                                                          .colorPrimary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      // '${LocaleKeys.grievancesScreen_locaiton.tr()} - ${state.grievanceList[index].address}',
                                                      '${state.grievanceList[index].address}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyles
                                                          .cardTextStyle
                                                          .copyWith(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 16.sp,
                                                    color:
                                                        AppColors.colorPrimary,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${state.grievanceList[index].createdByName}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyles
                                                          .cardTextStyle
                                                          .copyWith(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_month,
                                                    size: 16.sp,
                                                    color:
                                                        AppColors.colorPrimary,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      DateFormatter.formatDate(
                                                        state
                                                            .grievanceList[
                                                                index]
                                                            .lastModifiedDate
                                                            .toString(),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppStyles
                                                          .cardTextStyle
                                                          .copyWith(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.all(14.sp),
                                            decoration: const BoxDecoration(
                                              color:
                                                  AppColors.colorPrimaryLight,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(5, 5),
                                                  blurRadius: 10,
                                                  color:
                                                      AppColors.cardShadowColor,
                                                ),
                                                BoxShadow(
                                                  offset: Offset(-5, -5),
                                                  blurRadius: 10,
                                                  color: AppColors.colorWhite,
                                                ),
                                              ],
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/icons/arrowright.svg',
                                              color: AppColors.colorPrimary,
                                              width: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      if (state is NoGrievanceFoundState) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            return BlocProvider.of<GrievancesBloc>(context).add(
                              LoadGrievancesEvent(
                                staffId: AuthBasedRouting
                                    .afterLogin.userDetails!.staffID!,
                                municipalityId: AuthBasedRouting
                                    .afterLogin.userDetails!.municipalityID!,
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              ListView(),
                              Center(
                                child: Text(LocaleKeys
                                    .grievancesScreen_noGrievanceErrorMessage
                                    .tr()),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowOnlyOpenSwitch extends StatefulWidget {
  const ShowOnlyOpenSwitch({
    Key? key,
  }) : super(key: key);

  // static bool showOnlyOpen = false;
  @override
  State<ShowOnlyOpenSwitch> createState() => ShowOnlyOpenSwitchState();
}

class ShowOnlyOpenSwitchState extends State<ShowOnlyOpenSwitch> {
  static bool showOnlyOpen = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: AppColors.colorPrimary,
      value: showOnlyOpen,
      onChanged: (value) {
        setState(() {
          showOnlyOpen = value;
        });
        if (value) {
          return BlocProvider.of<GrievancesBloc>(context)
              .add(ShowOnlyOpenGrievancesEvent());
        } else {
          return BlocProvider.of<GrievancesBloc>(context).add(
            LoadGrievancesEvent(
              municipalityId: AuthBasedRouting
                  .afterLogin.userDetails!.municipalityID
                  .toString(),
              staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
            ),
          );
        }
      },
    );
  }
}
