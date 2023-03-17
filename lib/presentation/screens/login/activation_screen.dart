import 'dart:developer';

import 'package:civic_staff/logic/cubits/authentication/authentication_cubit.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/presentation/screens/home/home.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class Activation extends StatefulWidget {
  final String mobileNumber;
  final Map<String, dynamic> userDetails;
  static const routeName = '/activation';
  const Activation({
    super.key,
    required this.mobileNumber,
    required this.userDetails,
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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
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
                              style: AppStyles.loginScreensAppNameTextStyle
                                  .copyWith(
                                color: AppColors.colorPrimary,
                                fontSize:
                                    constraints.maxWidth > 600 ? 28.sp : 30.sp,
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              LocaleKeys.loginAndActivationScreen_welcome.tr(),
                              style: AppStyles.loginScreensWelcomeTextStyle
                                  .copyWith(
                                color: AppColors.colorPrimary,
                              ),
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
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenPadding),
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
                            style:
                                AppStyles.loginScreensInputFieldTitleTextStyle,
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
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor:
                                                  AppColors.colorPrimary,
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
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor:
                                                  AppColors.colorPrimary,
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
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor:
                                                  AppColors.colorPrimary,
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
                                            child: BlocBuilder<
                                                AuthenticationCubit,
                                                AuthenticationState>(
                                              builder: (context, state) {
                                                if (state is OtpSentState) {}
                                                return TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor:
                                                      AppColors.colorPrimary,
                                                  textAlign: TextAlign.center,
                                                  focusNode: focusNode4,
                                                  onChanged: (value) {
                                                    if (value.length == 1) {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (otpController1.text.isNotEmpty &&
                                                          otpController2.text
                                                              .isNotEmpty &&
                                                          otpController3.text
                                                              .isNotEmpty &&
                                                          otpController4.text
                                                              .isNotEmpty) {
                                                        // Navigator.of(context)
                                                        //     .pushNamed(
                                                        //   HomeScreen.routeName,
                                                        // );
                                                      }
                                                    }
                                                    if (value.isEmpty) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNode3);
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
                                                    fillColor: AppColors
                                                        .colorPrimaryLight,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16.sp,
                                                      vertical: 0.sp,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.sp),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    hintMaxLines: 1,
                                                  ),
                                                  controller: otpController4,
                                                );
                                              },
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
                                          .copyWith(fontSize: 12.sp),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        BlocProvider.of<AuthenticationCubit>(
                                                context)
                                            .signIn(widget.mobileNumber, true);
                                      },
                                      child: Text(
                                        LocaleKeys
                                            .loginAndActivationScreen_resendOtp
                                            .tr(),
                                        style: AppStyles
                                            .loginScreensResendOtpTextStyle,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          BlocConsumer<AuthenticationCubit,
                              AuthenticationState>(
                            listener: (context, state) {
                              if (state is AuthenticationSuccessState) {
                                BlocProvider.of<LocalStorageCubit>(context)
                                    .storeUserData(state.afterLogin);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName,
                                  (route) => false,
                                );
                              }
                              if (state is AuthenticationOtpErrorState) {
                                SnackBars.errorMessageSnackbar(
                                  context,
                                  state.error,
                                );
                                otpController1.clear();
                                otpController2.clear();
                                otpController3.clear();
                                otpController4.clear();
                                // showDialog(
                                //   context: context,
                                //   builder: (context) => AlertDialog(
                                //     actions: [
                                //       ElevatedButton(
                                //         onPressed: () =>
                                //             Navigator.of(context).pop(),
                                //         child: const Text('Ok'),
                                //       ),
                                //     ],
                                //     contentPadding: EdgeInsets.all(20.sp),
                                //     content: Text(
                                //       state.error,
                                //     ),
                                //   ),
                                // );
                              }
                              if (state is OtpSentSucessfully) {
                                SnackBars.sucessMessageSnackbar(
                                  context,
                                  'Otp has been sent to your mobile number',
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthenticationLoading) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: PrimaryButton(
                                    isLoading: true,
                                    buttonText: LocaleKeys
                                        .loginAndActivationScreen_continue
                                        .tr(),
                                    onTap: () async {},
                                  ),
                                );
                              }
                              if (state is NavigateToActivationState) {
                                return submitOtpButton(state, context);
                              }
                              if (state is OtpSentState) {
                                return submitOtpButton(state, context);
                              }
                              return Align(
                                alignment: Alignment.centerRight,
                                child: PrimaryButton(
                                  isLoading: false,
                                  enabled: false,
                                  buttonText: LocaleKeys
                                      .loginAndActivationScreen_continue
                                      .tr(),
                                  onTap: () async {
                                    log('Nothing');
                                  },
                                ),
                              );
                            },
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
        );
      }),
      bottomNavigationBar: const LoginShapeBottom(),
    );
  }

  Align submitOtpButton(var state, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: PrimaryButton(
        isLoading: false,
        buttonText: LocaleKeys.loginAndActivationScreen_continue.tr(),
        onTap: () async {
          if (_formKey.currentState!.validate() &&
              otpController1.text.isNotEmpty &&
              otpController2.text.isNotEmpty &&
              otpController3.text.isNotEmpty &&
              otpController4.text.isNotEmpty) {
            log(state.sessionId);
            log(state.username);
            BlocProvider.of<AuthenticationCubit>(context).verifyOtp(
              {
                "username": state.username,
                "session": state.sessionId,
                "phone_number": state.phoneNumber,
                "user_type": 'STAFF',
              },
              otpController1.text +
                  otpController2.text +
                  otpController3.text +
                  otpController4.text,
            );
          } else {
            SnackBars.errorMessageSnackbar(
                context, 'OTP fields cannot be empty!');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(focusNode1);
            });
          }
        },
      ),
    );
  }
}
