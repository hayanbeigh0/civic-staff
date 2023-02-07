import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_bottom.dart';
import 'package:civic_staff/presentation/utils/shapes/login_shape_top.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';
  Login({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();

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
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
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
                          'Mobile Number',
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
                          height: 70.h,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              children: [
                                Expanded(
                                  child: androidTextField(context),
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
                            buttonText: 'Continue',
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
      ),
      bottomNavigationBar: const LoginShapeBottom(),
    );
  }

  TextFormField androidTextField(BuildContext context) {
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

        // prefixIcon: const Icon(Icons.call),
        hintText: '123-7281-927',
        hintStyle: GoogleFonts.montserrat(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      ),
    );
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits long';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Mobile number can only contain digits';
    }
    return null;
  }
}
