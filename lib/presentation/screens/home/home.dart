// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/logic/cubits/authentication/authentication_cubit.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/home_grid_items/home_grid_items_cubit.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/presentation/screens/home/enroll_user/enroll_user.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
import 'package:civic_staff/presentation/screens/home/profile/profile.dart';
import 'package:civic_staff/presentation/screens/home/search_user/search_user.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_bottom_shape.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:civic_staff/models/grid_tile_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final TextEditingController _searchController = TextEditingController();
  HomeScreen({super.key});
  final List<HomeGridTile> gridItems = [
    HomeGridTile(
      routeName: EnrollUser.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3.5,
        child: SvgPicture.asset('assets/svg/enrolluser.svg'),
      ),
      gridTileTitle: LocaleKeys.homeScreen_enrollUser.tr(),
    ),
    HomeGridTile(
      routeName: GrievanceList.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/monitorgrievances.svg'),
      ),
      gridTileTitle: LocaleKeys.homeScreen_monitorGrievances.tr(),
    ),
    HomeGridTile(
      routeName: SearchUser.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3.5,
        child: SvgPicture.asset('assets/svg/search.svg'),
      ),
      gridTileTitle: LocaleKeys.homeScreen_searchUser.tr(),
    ),
    HomeGridTile(
      routeName: ProfileScreen.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/profile.svg'),
      ),
      gridTileTitle: LocaleKeys.homeScreen_profile.tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CurrentLocationCubit>(context).getCurrentLocation();
    BlocProvider.of<HomeGridItemsCubit>(context).loadAllGridItems();
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
                    height: 30.h,
                  ),
                  SafeArea(
                    bottom: false,
                    child: Text(
                      LocaleKeys.appName.tr(),
                      style: AppStyles.dashboardAppNameStyle
                          .copyWith(fontSize: 24.sp),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BlocBuilder<LocalStorageCubit, LocalStorageState>(
                    builder: (context, state) {
                      if (state is LocalStorageFetchingDoneState) {
                        return Text(
                          state.afterLogin.masterData!
                              .firstWhere((element) =>
                                  element.sK ==
                                  state.afterLogin.userDetails!.municipalityID!)
                              .name!,
                          style: AppStyles.dashboardAppNameStyle
                              .copyWith(fontSize: 18.sp),
                        );
                      }
                      return const SizedBox();
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
            child: Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 12.0.h,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
              ),
              child: BlocBuilder<HomeGridItemsCubit, HomeGridItemsState>(
                builder: (context, state) {
                  if (state is HomeGridItemsLoaded) {
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 30.w,
                        mainAxisSpacing: 30.w,
                      ),
                      itemCount: state.gridItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(
                            20.r,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              state.gridItems[index].routeName,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimaryExtraLight,
                              borderRadius: BorderRadius.circular(
                                20.r,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Color.fromARGB(87, 40, 97, 204),
                                ),
                                BoxShadow(
                                  offset: Offset(-1, -1),
                                  blurRadius: 2,
                                  color: AppColors.colorWhite,
                                  blurStyle: BlurStyle.normal,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                ),
                                state.gridItems[index].gridIcon,
                                Expanded(
                                  child: Container(
                                    width: 100.w,
                                    alignment: Alignment.center,
                                    child: Text(
                                      state.gridItems[index].gridTileTitle,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.gridTileTitle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PrimaryBottomShape(
        height: 80.h,
      ),
    );
  }
}
