import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/cubits/authentication/authentication_cubit.dart';
import 'package:civic_staff/presentation/screens/login/activation_screen.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/services/auth_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

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
                          style:
                              AppStyles.loginScreensAppNameTextStyle.copyWith(
                            fontSize:
                                constraints.maxWidth > 600 ? 28.sp : 34.sp,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxWidth > 600 ? 10.h : 30.h,
                        ),
                        Text(
                          LocaleKeys.loginAndActivationScreen_welcome.tr(),
                          style:
                              AppStyles.loginScreensWelcomeTextStyle.copyWith(
                            fontSize:
                                constraints.maxWidth > 600 ? 16.sp : 20.sp,
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
                      style: AppStyles.loginScreensHeadingTextStyle.copyWith(
                        fontSize: constraints.maxWidth > 600 ? 18.sp : 24.sp,
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
                            style: AppStyles
                                .loginScreensInputFieldTitleTextStyle
                                .copyWith(
                              fontSize:
                                  constraints.maxWidth > 600 ? 10.sp : 12.sp,
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
                          BlocConsumer<AuthenticationCubit,
                              AuthenticationState>(
                            listener: (context, state) {
                              if (state is NavigateToActivationState) {
                                SnackBars.sucessMessageSnackbar(
                                  context,
                                  'Otp has been sent to your mobile number',
                                );
                                // log('OTP sent state: ${state.sessionId}');
                                Navigator.of(context).pushNamed(
                                  Activation.routeName,
                                  arguments: {
                                    'mobileNumber':
                                        _mobileNumberController.text,
                                    'userDetails': {
                                      "username": state.username,
                                      "session": state.sessionId,
                                    }
                                  },
                                );
                              }
                              if (state is AuthenticationLoginErrorState) {
                                log('hello from login');
                                SnackBars.errorMessageSnackbar(
                                    context, state.error);
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

                              return Align(
                                alignment: Alignment.centerRight,
                                child: PrimaryButton(
                                  isLoading: false,
                                  buttonText: LocaleKeys
                                      .loginAndActivationScreen_continue
                                      .tr(),
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // Map signIn_repsonse =  await Auth_Api().signIn(_mobileNumberController.text);
                                      // Map<String, dynamic> userDetails = jsonDecode(signIn_repsonse['body']);
                                      BlocProvider.of<AuthenticationCubit>(
                                              context)
                                          .signIn(_mobileNumberController.text,
                                              false);
                                      // Navigator.of(context).pushNamed(
                                      //   '/activation',
                                      //   arguments: {
                                      //     'mobileNumber':
                                      //         _mobileNumberController.text,
                                      //     'userDetails':userDetails
                                      //   },
                                      // );
                                    } else {}
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
