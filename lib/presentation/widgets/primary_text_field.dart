import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextField extends StatelessWidget {
  const PrimaryTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.suffixIcon = const SizedBox(),
    this.maxLines = 1,
    required this.textEditingController,
    this.fieldValidator,
    this.focusNode,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.enabled = true,
  });
  final String title;
  final String hintText;
  final Widget suffixIcon;
  final int maxLines;
  final bool enabled;

  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  // final String fieldValidator;
  final String? Function(String?)? fieldValidator;
  final void Function(String?)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == ''
            ? const SizedBox()
            : Text(
                title,
                style: AppStyles.inputAndDisplayTitleStyle,
              ),
        SizedBox(
          height: 5.h,
        ),
        TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          maxLines: maxLines,
          style: AppStyles.primaryTextFieldStyle,
          inputFormatters: inputFormatters,
          controller: textEditingController,
          enabled: enabled,
          validator: fieldValidator,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? AppColors.colorPrimaryLight
                : AppColors.colorDisabledTextField,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 10.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintMaxLines: maxLines,
            errorStyle: AppStyles.errorTextStyle,
            hintStyle: AppStyles.primaryTextFieldHintStyle,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
