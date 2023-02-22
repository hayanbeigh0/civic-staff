import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.isLoading,
    this.enabled = true,
  }) : super(key: key);

  final VoidCallback onTap;
  final String buttonText;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading && !enabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 12.sp,
          horizontal: 18.sp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.r,
          ),
        ),
        primary: AppColors.colorPrimary,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: AppStyles.primaryButtonTextStyle.copyWith(
                fontSize: constraints.maxWidth > 600 ? 10.sp : 14.sp,
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
                        color: AppColors.colorWhite,
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    'assets/icons/arrowright.svg',
                    width: constraints.maxWidth > 600 ? 16.w : 20.w,
                  ),
          ],
        );
      }),
    );
  }
}
