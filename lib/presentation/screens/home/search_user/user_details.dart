import 'dart:async';
import 'dart:io';

import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';

import 'package:flutter/material.dart';
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
  final User user;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'User Details',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName.toString(),
                            style: TextStyle(
                              color: AppColors.colorWhite,
                              fontFamily: 'LexendDeca',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            user.city.toString(),
                            style: TextStyle(
                              color: AppColors.colorWhite,
                              fontFamily: 'LexendDeca',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
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
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
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
                          'Call',
                          style: TextStyle(
                            color: AppColors.colorTextGreen,
                            fontFamily: 'LexendDeca',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
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
                        user.email.toString(),
                        style: TextStyle(
                          color: AppColors.colorWhite,
                          fontFamily: 'LexendDeca',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          height: 1,
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
                padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: TextStyle(
                        color: AppColors.textColorDark,
                        fontFamily: 'LexendDeca',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
                        style: TextStyle(
                          overflow: TextOverflow.fade,
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          height: 1.1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'Location',
                      style: TextStyle(
                        color: AppColors.textColorDark,
                        fontFamily: 'LexendDeca',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Stack(
                      children: [
                        LocationMapField(
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
                      height: 12.h,
                    ),
                    PrimaryDisplayField(
                      title: 'Ward',
                      value: '${user.wardNumber}',
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PrimaryButton(
                        buttonText: 'Contact',
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
      ),
    );
  }
}
