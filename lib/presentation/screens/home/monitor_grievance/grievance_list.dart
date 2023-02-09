import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
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
                horizontal: 18.0.w,
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
                          child: SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            color: AppColors.colorWhite,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Grievances',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                            GrievanceMap.routeName,
                          ),
                          child: Text(
                            'View Map',
                            style: TextStyle(
                              color: AppColors.colorWhite,
                              fontFamily: 'LexendDeca',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
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
                        vertical: 0.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search by grievance type',
                      hintStyle: TextStyle(
                        color: AppColors.textColorLight,
                        fontFamily: 'LexendDeca',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.sp,
                          horizontal: 20.sp,
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/searchfieldsuffix.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        BlocProvider.of<GrievancesBloc>(context).add(
                          LoadGrievancesEvent(),
                        );
                      }
                      if (value.isNotEmpty) {
                        BlocProvider.of<GrievancesBloc>(context).add(
                            SearchGrievanceByTypeEvent(grievanceType: value));
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
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Results ordered by date and time',
                            style: TextStyle(
                              color: AppColors.colorGreyLight,
                              fontFamily: 'LexendDeca',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          // InkWell(
                          //   onTap: () {},
                          //   child: Text(
                          //     'Change Filter',
                          //     style: TextStyle(
                          //       color: AppColors.colorPrimary,
                          //       fontFamily: 'LexendDeca',
                          //       fontSize: 9.sp,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
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
                                horizontal: 10.w,
                                vertical: 15.h,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 18.w,
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
                                          style: TextStyle(
                                            color: AppColors.cardTextColor,
                                            fontFamily: 'LexendDeca',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: AppColors.cardTextColor,
                                            fontFamily: 'LexendDeca',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: AppColors.cardTextColor,
                                            fontFamily: 'LexendDeca',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          '',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: AppColors.cardTextColor,
                                            fontFamily: 'LexendDeca',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
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
  const GrievanceListWidget({
    Key? key,
    this.state = const GrievancesLoadedState(
      grievanceList: [],
      selectedFilterNumber: 1,
    ),
  }) : super(key: key);
  final GrievancesLoadedState state;
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
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 15.h,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 18.w,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.grievanceList[index].grievanceType.toString(),
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Location - ${state.grievanceList[index].place}',
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Raised by - ${state.grievanceList[index].raisedBy}',
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Date - ${DateFormatter.formatDate(
                          state.grievanceList[index].timeStamp.toString(),
                        )}',
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.cardTextColor,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100.r),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(GrievanceDetail.routeName, arguments: {
                        "state": state,
                        "index": index,
                      });
                    },
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
