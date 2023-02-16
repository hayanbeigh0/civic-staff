import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
                                LocaleKeys.grievanceDetail_photosAndVideos.tr(),
                                style: AppStyles.screenTitleStyle,
                              ),
                            ],
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
                horizontal: AppConstants.screenPadding,
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
                        color: AppColors.colorPrimaryExtraLight,
                        borderRadius: BorderRadius.circular(
                          20.r,
                        ),
                      ),
                      child: VideoWidget(
                        url: state.grievanceList[grievanceListIndex].videos![
                            index -
                                state.grievanceList[grievanceListIndex].photos!
                                    .length],
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
      // bottomNavigationBar: PrimaryBottomShape(
      //   height: 80.h,
      // ),
    );
  }
}
