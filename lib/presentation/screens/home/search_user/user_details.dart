import 'dart:async';

import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/presentation/screens/home/enroll_user/edit_user.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetails extends StatelessWidget {
  static const routeName = '/userDetails';
  UserDetails({
    super.key,
    required this.user,
  });
  User user;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          userDetails(context),
          BlocConsumer<UsersBloc, SearchUsersState>(
            listener: (context, state) {
              if (state is UserEditedState) {
                user = state.user;
              }
              if (state is LoadedUserByIdState) {
                Navigator.of(context).pushReplacementNamed(
                  UserDetails.routeName,
                  arguments: {'user': state.user},
                );
              }
            },
            builder: (context, state) {
              if (state is EditingAUserState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorPrimary,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  userDetails(BuildContext context) {
    return Column(
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
                        LocaleKeys.userDetails_screenTitle.tr(),
                        style: AppStyles.screenTitleStyle,
                      ),
                      const Spacer(),
                      BlocListener<UsersBloc, SearchUsersState>(
                        listener: (context, state) {
                          if (state is UserEditedState) {
                            Navigator.of(context).pushReplacementNamed(
                              UserDetails.routeName,
                              arguments: {'user': state.user},
                            );
                          }
                        },
                        child: InkWell(
                          onTap: () async {
                            await Navigator.of(context).pushNamed(
                              EditUserScreen.routeName,
                              arguments: {
                                'user': user,
                              },
                            );
                            // if(mounted){}
                            // BlocProvider.of<UsersBloc>(context).add(
                            //   const LoadUsersEvent(1),
                            // );
                            BlocProvider.of<UsersBloc>(context).add(
                              GetUserByIdEvent(
                                userId: user.userId.toString(),
                              ),
                            );
                          },
                          child: Text(
                            LocaleKeys.profile_edit.tr(),
                            style: AppStyles.appBarActionsTextStyle,
                          ),
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
                        backgroundColor: AppColors.colorPrimaryExtraLight,
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    user.firstName.toString(),
                                    maxLines: 1,
                                    style: AppStyles.userDisplayNameTextStyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  user.address.toString(),
                                  maxLines: 1,
                                  style: AppStyles.userDisplayCityTextStyle,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<UsersBloc>(context).add(
                                EditUserEvent(
                                  user: User(
                                    userId: user.userId,
                                    about: user.about,
                                    active: user.active! ? false : true,
                                    address: user.address,
                                    countryCode: user.countryCode,
                                    createdDate: user.createdDate,
                                    emailId: user.emailId,
                                    firstName: user.firstName,
                                    lastModifiedDate: user.lastModifiedDate,
                                    lastName: user.lastName,
                                    latitude: user.latitude,
                                    longitude: user.longitude,
                                    mobileNumber: user.mobileNumber,
                                    municipalityId: user.municipalityId,
                                    notificationToken: user.notificationToken,
                                    profilePicture: user.profilePicture,
                                    staffId: user.staffId,
                                    wardNumber: user.wardNumber,
                                  ),
                                ),
                              );
                            },
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Text(
                              user.active! ? 'Disable User' : 'Enable User',
                              style:
                                  AppStyles.userDetailsCallTextStyle.copyWith(
                                color: AppColors.colorPrimary200,
                              ),
                            ),
                          )
                        ],
                      ),
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
                    InkWell(
                      onTap: () async {
                        final url = 'tel:${user.mobileNumber}';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        user.mobileNumber.toString(),
                        style: AppStyles.userContactDetailsMobileNumberStyle,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        final url = 'tel:${user.mobileNumber}';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        LocaleKeys.userDetails_call.tr(),
                        style: AppStyles.userDetailsCallTextStyle,
                      ),
                    ),
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
                      user.emailId.toString(),
                      style: AppStyles.userContactDetailsMobileNumberStyle,
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
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.userDetails_about.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: AppColors.colorPrimaryLight,
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Text(
                      user.about.toString(),
                      style: AppStyles.primaryTextFieldStyle,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PrimaryDisplayField(
                    title: 'Muncipality',
                    value: user.municipalityId.toString(),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PrimaryDisplayField(
                    title: 'Ward',
                    value: user.wardNumber.toString(),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    LocaleKeys.userDetails_location.tr(),
                    style: AppStyles.inputAndDisplayTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Stack(
                    children: [
                      LocationMapField(
                        markerEnabled: true,
                        myLocationEnabled: false,
                        zoomEnabled: false,
                        latitude: double.parse(user.latitude.toString()),
                        longitude: double.parse(user.latitude.toString()),
                        mapController: _controller,
                      ),
                      Container(
                        height: 180.h,
                        width: double.infinity,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: PrimaryButton(
                      buttonText: LocaleKeys.userDetails_contact.tr(),
                      isLoading: false,
                      onTap: () {},
                      enabled: true,
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

  String? validateWardNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_wardDropdownError.tr();
    }
    return null;
  }
}
