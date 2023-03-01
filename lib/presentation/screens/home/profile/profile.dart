import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/presentation/screens/home/profile/edit_profile.dart';
import 'package:civic_staff/presentation/screens/login/login.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/secondary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profileScreen';
  const ProfileScreen({super.key});
  // final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MyProfileCubit>(context).loadMyProfile();
    return Scaffold(
      body: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
          if (state is MyProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.colorPrimary),
            );
          }
          if (state is MyProfileLoaded) {
            return Column(
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
                                      LocaleKeys.profile_screenTitle.tr(),
                                      style: AppStyles.screenTitleStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    EditProfileScreen.routeName,
                                    arguments: {
                                      'my_profile': state.myProfile,
                                    },
                                  ).then(
                                    (_) =>
                                        BlocProvider.of<MyProfileCubit>(context)
                                            .loadMyProfile(),
                                  );
                                },
                                child: Text(
                                  LocaleKeys.profile_edit.tr(),
                                  style: AppStyles.appBarActionsTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40.w,
                              backgroundColor: AppColors.colorPrimary,
                              child: CircleAvatar(
                                radius: 38.w,
                                backgroundColor:
                                    AppColors.colorPrimaryExtraLight,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.myProfile.firstName.toString(),
                                  style: AppStyles.userDisplayNameTextStyle,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  state.myProfile.city.toString(),
                                  style: AppStyles.userDisplayCityTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: AppColors.colorWhite,
                              size: 16.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              state.myProfile.mobileNumber.toString(),
                              style:
                                  AppStyles.userDisplayCityTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppColors.colorWhite,
                              size: 16.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              state.myProfile.email.toString(),
                              style:
                                  AppStyles.userDisplayCityTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.profile_about.tr(),
                            style: AppStyles.inputAndDisplayTitleStyle,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: AppColors.colorPrimaryLight,
                            ),
                            padding: EdgeInsets.all(10.sp),
                            child: Text(
                              state.myProfile.about.toString(),
                              style: AppStyles.primaryTextFieldStyle,
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            LocaleKeys.profile_allocatedGrievancesAndWards.tr(),
                            style: AppStyles.inputAndDisplayTitleStyle,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimaryLight,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.myProfile.allocatedWards!
                                  .map(
                                    (e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0.sp,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          state.myProfile.allocatedWards!
                                                      .indexOf(e) ==
                                                  0
                                              ? const SizedBox()
                                              : const Divider(
                                                  height: 1.1,
                                                  color:
                                                      AppColors.colorGreyLight,
                                                ),
                                          Text(
                                            '${e.grievanceType}: ',
                                            style: AppStyles
                                                .inputAndDisplayTitleStyle,
                                          ),

                                          ...e.wardNumber!
                                              .toList()
                                              .map(
                                                (e) => Column(
                                                  children: [
                                                    Text(
                                                      e,
                                                      style: AppStyles
                                                          .descriptiveTextStyle
                                                          .copyWith(
                                                        height: null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                          // e.indexOf(e) <
                                          //               state
                                          //                       .myProfile
                                          //                       .allocatedWards!
                                          //                       .length -
                                          //                   1
                                          //           ?
                                          // Divider(
                                          //   height: 1.1,
                                          //   color: AppColors.colorGreyLight,
                                          // )
                                          // : SizedBox()
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SecondaryButton(
                              buttonText: LocaleKeys.profile_logout.tr(),
                              isLoading: false,
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Login.routeName,
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
