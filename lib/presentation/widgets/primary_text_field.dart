import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
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
  });
  final String title;
  final String hintText;
  final Widget suffixIcon;
  final int maxLines;
  final TextEditingController textEditingController;
  // final String fieldValidator;
  final String? Function(String?)? fieldValidator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == ''
            ? const SizedBox()
            : Text(
                title,
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
        TextFormField(
          enabled: true,
          validator: fieldValidator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.colorPrimaryLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 0.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintMaxLines: maxLines,
            hintStyle: TextStyle(
              overflow: TextOverflow.fade,
              color: AppColors.textColorLight,
              fontFamily: 'LexendDeca',
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
              height: 1.1,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
