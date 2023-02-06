import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class Activation extends StatelessWidget {
  final String mobileNumber;
  static const routeName = '/activation';
  Activation({
    super.key,
    required this.mobileNumber,
  });
  final _formKey = GlobalKey<FormState>();

  final OtpFieldController otpController = OtpFieldController();
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
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Civic',
                            style: TextStyle(
                              color: AppColors.colorPrimaryDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            'Welcome\nBack',
                            style: TextStyle(
                              color: AppColors.colorSecondaryDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.colorPrimary,
                      fontFamily: 'LexendDeca',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
                          'Enter OTP',
                          style: TextStyle(
                            color: AppColors.textColorDark,
                            fontFamily: 'LexendDeca',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 100.h,
                          child: Column(
                            children: [
                              OTPTextField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                otpFieldStyle: OtpFieldStyle(
                                  borderColor: Colors.transparent,
                                  enabledBorderColor: Colors.transparent,
                                  backgroundColor: AppColors.colorPrimaryLight,
                                ),
                                length: 4,
                                width: double.infinity,
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldWidth: 60.w,
                                fieldStyle: FieldStyle.box,
                                outlineBorderRadius: 8,
                                spaceBetween: 24.w,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                    4,
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  height: 2.h,
                                ),
                                onChanged: (pin) {
                                  // print("Changed: " + pin);
                                },
                                onCompleted: (pin) {
                                  // print("Completed: " + pin);
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Didn’t receive the OTP yet?',
                                    style: TextStyle(
                                      color: AppColors.textColorDark,
                                      fontFamily: 'LexendDeca',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      color: AppColors.textColorRed,
                                      fontFamily: 'LexendDeca',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton(
                            isLoading: false,
                            buttonText: 'Continue',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushNamed(
                                  '/home',
                                );
                              } else {}
                            },
                          ),
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
