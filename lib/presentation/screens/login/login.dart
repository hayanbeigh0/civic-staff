import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';
  Login({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();

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
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.appName.tr(),
                          style: TextStyle(
                            color: AppColors.colorPrimaryDark,
                            fontFamily: 'LexendDeca',
                            fontSize:
                                constraints.maxWidth > 600 ? 28.sp : 34.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxWidth > 600 ? 10.h : 30.h,
                        ),
                        Text(
                          LocaleKeys.loginAndActivationScreen_welcome.tr(),
                          style: TextStyle(
                            color: AppColors.colorSecondaryDark,
                            fontFamily: 'LexendDeca',
                            fontSize:
                                constraints.maxWidth > 600 ? 16.sp : 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
                      height: constraints.maxWidth > 600 ? 10.h : 20.h,
                    ),
                    Text(
                      LocaleKeys.loginAndActivationScreen_login.tr(),
                      style: TextStyle(
                        color: AppColors.colorPrimary,
                        fontFamily: 'LexendDeca',
                        fontSize: constraints.maxWidth > 600 ? 18.sp : 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxWidth > 600 ? 20.h : 30.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.loginAndActivationScreen_mobileNumber
                                .tr(),
                            style: TextStyle(
                              color: AppColors.textColorDark,
                              fontFamily: 'LexendDeca',
                              fontSize:
                                  constraints.maxWidth > 600 ? 10.sp : 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: constraints.maxWidth > 600 ? 50.h : 70.h,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        androidTextField(context, constraints),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
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
                                    '/activation',
                                    arguments: {
                                      'mobileNumber':
                                          _mobileNumberController.text,
                                    },
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
        );
      }),
      bottomNavigationBar: const LoginShapeBottom(),
    );
  }

  TextFormField androidTextField(
      BuildContext context, BoxConstraints constraints) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(
        bottom: 5.h,
      ),
      validator: (value) => validateMobileNumber(
        value.toString(),
      ),
      onChanged: (value) {
        if (value.length == 10) {
          FocusScope.of(context).unfocus();
        }
      },
      controller: _mobileNumberController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 12.sp,
        ),
        fillColor: AppColors.colorPrimaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8.r,
          ),
          borderSide: BorderSide.none,
        ),
        // style:
        errorStyle: TextStyle(fontSize: 10.sp),
        // prefixIcon: const Icon(Icons.call),
        hintText: LocaleKeys.loginAndActivationScreen_textFieldHint.tr(),
        hintStyle: TextStyle(
          fontSize: constraints.maxWidth > 600 ? 14.sp : 16.sp,
          color: Colors.grey,
        ),
      ),
    );
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.loginAndActivationScreen_mobileNumberRequiredError.tr();
    }
    if (value.length != 10) {
      return LocaleKeys.loginAndActivationScreen_mobileNumberLengthError.tr();
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return LocaleKeys.loginAndActivationScreen_mobileNumberInputTypeError
          .tr();
    }
    return null;
  }
}
