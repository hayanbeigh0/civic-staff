import 'dart:developer';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/presentation/screens/home/home.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class Activation extends StatefulWidget {
  final String mobileNumber;
  static const routeName = '/activation';
  const Activation({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<Activation> createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController otpController1 = TextEditingController();

  final TextEditingController otpController2 = TextEditingController();

  final TextEditingController otpController3 = TextEditingController();

  final TextEditingController otpController4 = TextEditingController();

  FocusNode focusNode1 = FocusNode();

  FocusNode focusNode2 = FocusNode();

  FocusNode focusNode3 = FocusNode();

  FocusNode focusNode4 = FocusNode();

  final double otpFieldSpacing = 20.w;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoginShapeTop(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.appName.tr(),
                            style: AppStyles.loginScreensAppNameTextStyle,
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            LocaleKeys.loginAndActivationScreen_welcome.tr(),
                            style: AppStyles.loginScreensWelcomeTextStyle,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: SvgPicture.asset(
                              'assets/icons/arrowleft.svg',
                              color: AppColors.colorPrimary,
                              height: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    LocaleKeys.loginAndActivationScreen_login.tr(),
                    style: AppStyles.loginScreensHeadingTextStyle,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.loginAndActivationScreen_enterOtp.tr(),
                          style: AppStyles.loginScreensInputFieldTitleTextStyle,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 100.h,
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppColors.colorPrimary,
                                            textAlign: TextAlign.center,
                                            focusNode: focusNode1,
                                            style: TextStyle(
                                              height: 1.5.h,
                                            ),
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode2);
                                              }
                                              if (value.isEmpty) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.colorPrimaryLight,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 16.sp,
                                                vertical: 0.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintMaxLines: 1,
                                            ),
                                            controller: otpController1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: otpFieldSpacing,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppColors.colorPrimary,
                                            textAlign: TextAlign.center,
                                            focusNode: focusNode2,
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode3);
                                              }
                                              if (value.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode1);
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.colorPrimaryLight,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 16.sp,
                                                vertical: 0.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintMaxLines: 1,
                                            ),
                                            controller: otpController2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: otpFieldSpacing,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppColors.colorPrimary,
                                            textAlign: TextAlign.center,
                                            focusNode: focusNode3,
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode4);
                                              }
                                              if (value.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode2);
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.colorPrimaryLight,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 16.sp,
                                                vertical: 0.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintMaxLines: 1,
                                            ),
                                            controller: otpController3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: otpFieldSpacing,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppColors.colorPrimary,
                                            textAlign: TextAlign.center,
                                            focusNode: focusNode4,
                                            onChanged: (value) {
                                              if (value.length == 1) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (otpController1.text.isNotEmpty &&
                                                    otpController2
                                                        .text.isNotEmpty &&
                                                    otpController3
                                                        .text.isNotEmpty &&
                                                    otpController4
                                                        .text.isNotEmpty) {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    HomeScreen.routeName,
                                                  );
                                                }
                                              }
                                              if (value.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode3);
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  1),
                                            ],
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.colorPrimaryLight,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 16.sp,
                                                vertical: 0.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintMaxLines: 1,
                                            ),
                                            controller: otpController4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys
                                        .loginAndActivationScreen_otpNotRecieved
                                        .tr(),
                                    style: AppStyles.inputAndDisplayTitleStyle
                                        .copyWith(fontSize: 400),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    LocaleKeys
                                        .loginAndActivationScreen_resendOtp
                                        .tr(),
                                    style: AppStyles
                                        .loginScreensResendOtpTextStyle,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton(
                            isLoading: false,
                            buttonText: LocaleKeys
                                .loginAndActivationScreen_continue
                                .tr(),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushNamed(
                                  '/home',
                                );
                              } else {}
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const LoginShapeBottom(),
    );
  }
}
