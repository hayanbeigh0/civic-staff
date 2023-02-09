import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/primary_bottom_shape.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrievancePhotoVideo extends StatelessWidget {
  static const routeName = '/grievancePhotoVideo';
  const GrievancePhotoVideo({
    super.key,
    required this.state,
    required this.grievanceListIndex,
  });
  final GrievancesLoadedState state;
  final int grievanceListIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Photo / Video',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
                vertical: 10.h,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 30.w,
                  mainAxisSpacing: 20.h,
                ),
                itemCount:
                    state.grievanceList[grievanceListIndex].photos!.length +
                        state.grievanceList[grievanceListIndex].videos!.length,
                itemBuilder: (context, index) {
                  if (index <
                      state.grievanceList[grievanceListIndex].photos!.length) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimaryExtraLight,
                        borderRadius: BorderRadius.circular(
                          20.r,
                        ),
                      ),
                      child: Image.network(
                        state.grievanceList[grievanceListIndex].photos![index],
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimaryLight,
                        borderRadius: BorderRadius.circular(
                          20.r,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {},
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
      bottomNavigationBar: PrimaryBottomShape(
        height: 80.h,
      ),
    );
  }
}
