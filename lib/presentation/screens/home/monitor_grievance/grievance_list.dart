import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
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

class GrievanceList extends StatelessWidget {
  static const routeName = '/grievanceList';
  GrievanceList({super.key});
  final TextEditingController _searchController = TextEditingController();
  GlobalKey roadmaintainance = GlobalKey();
  GlobalKey streetlighting = GlobalKey();
  GlobalKey watersupplyanddrainage = GlobalKey();
  GlobalKey garbagecollection = GlobalKey();
  GlobalKey certificaterequest = GlobalKey();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GrievancesBloc>(context).add(
      LoadGrievancesEvent(),
    );
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
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                            GrievanceMap.routeName,
                          ),
                          child: Text(
                            LocaleKeys.grievancesScreen_viewMap.tr(),
                            style: AppStyles.appBarActionsTextStyle,
                          ),
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
                          LoadGrievancesEvent(),
                        );
                      }
                      if (value.isNotEmpty) {
                        return BlocProvider.of<GrievancesBloc>(context).add(
                          SearchGrievanceByTypeEvent(grievanceType: value),
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
                        return GrievanceListWidget(
                          state: state,
                        );
                      }
                      if (state is NoGrievanceFoundState) {
                        return const Center(
                          child: Text('No Grievance Found'),
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

class GrievanceListWidget extends StatelessWidget {
  GrievanceListWidget({
    Key? key,
    this.state = const GrievancesLoadedState(
      grievanceList: [],
      selectedFilterNumber: 1,
    ),
  }) : super(key: key);
  final GrievancesLoadedState state;
  final Map<String, String> svgList = {
    "roadmaintainance": 'assets/svg/roadmaintainance.svg',
    "streetlighting": 'assets/svg/streetlighting.svg',
    "watersupplyanddrainage": 'assets/svg/watersupplyanddrainage.svg',
    "garbagecollection": 'assets/svg/garbagecollection.svg',
    "garb": 'assets/svg/garbagecollection.svg',
    "certificaterequest": 'assets/svg/certificaterequest.svg',
  };
  final Map<String, String> grievanceTypesMap = {
    "garb": 'Garbage Collection',
  };

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.colorPrimary,
      onRefresh: () async {
        BlocProvider.of<GrievancesBloc>(context).add(LoadGrievancesEvent());
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        itemCount: state.grievanceList.isEmpty ? 8 : state.grievanceList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            // borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(GrievanceDetail.routeName, arguments: {
                "state": state,
                "index": index,
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
                    svgList[state.grievanceList[index].grievanceType!
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          grievanceTypesMap[state
                                  .grievanceList[index].grievanceType!
                                  .toLowerCase()]
                              .toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.cardTextStyle,
                        ),
                        Text(
                          '${LocaleKeys.grievancesScreen_locaiton.tr()} - ${state.grievanceList[index].address}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${LocaleKeys.grievancesScreen_reporter.tr()} - ${state.grievanceList[index].createdByName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${LocaleKeys.grievancesScreen_date.tr()} - ${DateFormatter.formatTimeStamp(
                            state.grievanceList[index].lastModifiedDate
                                .toString(),
                          )}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.cardTextStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      padding: EdgeInsets.all(14.sp),
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
