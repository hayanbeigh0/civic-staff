import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryDisplayField extends StatelessWidget {
  const PrimaryDisplayField({
    Key? key,
    required this.title,
    required this.value,
    this.maxLines = 1,
    this.suffixIcon = const SizedBox(),
  }) : super(key: key);
  final String title;
  final String value;
  final Widget suffixIcon;
  final int maxLines;

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
        TextField(
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.colorPrimaryLight,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 10.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sp),
              borderSide: BorderSide.none,
            ),
            hintText: value,
            hintMaxLines: maxLines,
            hintStyle: TextStyle(
              overflow: TextOverflow.fade,
              color: AppColors.textColorDark,
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
