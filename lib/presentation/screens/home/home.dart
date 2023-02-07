// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:civic_staff/presentation/screens/home/enroll_user/enroll_user.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
import 'package:civic_staff/presentation/screens/home/profile/profile.dart';
import 'package:civic_staff/presentation/screens/home/search_user/search_user.dart';
import 'package:civic_staff/presentation/widgets/primary_bottom_shape.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter/material.dart';
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
      gridTileTitle: 'Enroll User',
    ),
    HomeGridTile(
      routeName: GrievanceList.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/monitorgrievances.svg'),
      ),
      gridTileTitle: 'Monitor Grievances',
    ),
    HomeGridTile(
      routeName: SearchUser.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3.5,
        child: SvgPicture.asset('assets/svg/search.svg'),
      ),
      gridTileTitle: 'Search User',
    ),
    HomeGridTile(
      routeName: ProfileScreen.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/profile.svg'),
      ),
      gridTileTitle: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: Column(
        children: [
          PrimaryTopShape(
            height: 230.h,
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
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: AppColors.colorWhite,
                        fontFamily: 'LexendDeca',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                      ),
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
                      hintText: 'Search',
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
                horizontal: 20.0.w,
                vertical: 12.0.h,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 30.w,
                  mainAxisSpacing: 20.h,
                ),
                itemCount: gridItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(
                      20.r,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        gridItems[index].routeName,
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
                          gridItems[index].gridIcon,
                          Expanded(
                            child: Container(
                              width: 100.w,
                              alignment: Alignment.center,
                              child: Text(
                                gridItems[index].gridTileTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textColorDark,
                                  fontFamily: 'LexendDeca',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                ),
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
