import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final String buttonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.colorWhite,
        primary: AppColors.colorPrimary,
        side: const BorderSide(
          color: AppColors.colorPrimary,
          width: 1.0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 12.sp,
          horizontal: 18.sp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.r,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonText,
            style: TextStyle(
              color: AppColors.colorPrimary,
              fontFamily: 'LexendDeca',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          isLoading
              ? Center(
                  child: SizedBox(
                    height: 20.sp,
                    width: 20.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/icons/arrowright.svg',
                  color: AppColors.colorPrimary,
                ),
        ],
      ),
    );
  }
}
