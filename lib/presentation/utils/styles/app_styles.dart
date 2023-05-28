import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static TextStyle errorTextStyle = TextStyle(
    color: AppColors.textColorRed,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle inputAndDisplayTitleStyle = TextStyle(
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle primaryTextFieldStyle = TextStyle(
    overflow: TextOverflow.fade,
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    height: 1.1,
  );
  static TextStyle primaryTextFieldHintStyle = TextStyle(
    overflow: TextOverflow.fade,
    color: AppColors.textColorLight,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    height: 1.1,
  );
  static TextStyle dashboardAppNameStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );
  static TextStyle searchHintStyle = TextStyle(
    color: AppColors.textColorLight,
    fontFamily: 'LexendDeca',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );
  static TextStyle gridTileTitle = TextStyle(
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 1.1,
  );
  static TextStyle screenTitleStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );
  static TextStyle dropdownTextStyle = TextStyle(
    overflow: TextOverflow.fade,
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    height: 1.1,
  );
  static TextStyle descriptiveTextStyle = TextStyle(
    overflow: TextOverflow.fade,
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    height: 1.1,
  );
  static TextStyle appBarActionsTextStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );
  static TextStyle listOrderedByTextStyle = TextStyle(
    color: AppColors.colorGreyLight,
    fontFamily: 'LexendDeca',
    fontSize: 9.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle cardTextStyle = TextStyle(
    color: AppColors.cardTextColor,
    fontFamily: 'LexendDeca',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle audioTitleTextStyle = TextStyle(
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle viewAllWhiteTextStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle userDisplayNameTextStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1,
  );
  static TextStyle userDisplayCityTextStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    height: 1,
  );
  static TextStyle userCardTitleTextStyle = TextStyle(
    color: AppColors.cardTextColor,
    fontFamily: 'LexendDeca',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle userCardTextStyle = TextStyle(
    color: AppColors.cardTextColor,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle userContactDetailsMobileNumberStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    height: 1,
  );
  static TextStyle userDetailsCallTextStyle = TextStyle(
    color: AppColors.colorTextGreen,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 1,
  );
  static TextStyle loginScreensAppNameTextStyle = TextStyle(
    color: AppColors.colorPrimaryDark,
    fontFamily: 'LexendDeca',
    fontSize: 34.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle loginScreensWelcomeTextStyle = TextStyle(
    color: AppColors.colorSecondaryDark,
    fontFamily: 'LexendDeca',
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle loginScreensHeadingTextStyle = TextStyle(
    color: AppColors.colorSecondaryDark,
    fontFamily: 'LexendDeca',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle loginScreensInputFieldTitleTextStyle = TextStyle(
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle loginScreensResendOtpTextStyle = TextStyle(
    color: AppColors.textColorRed,
    fontFamily: 'LexendDeca',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle dateTextDarkStyle = TextStyle(
    overflow: TextOverflow.fade,
    color: AppColors.textColorDark,
    fontFamily: 'LexendDeca',
    fontSize: 8.sp,
    fontWeight: FontWeight.w300,
    height: 1.1,
  );
  static TextStyle dateTextWhiteStyle = TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontSize: 10.sp,
    fontWeight: FontWeight.w300,
  );
  static TextStyle primaryButtonTextStyle = const TextStyle(
    color: AppColors.colorWhite,
    fontFamily: 'LexendDeca',
    fontWeight: FontWeight.w500,
  );
  static TextStyle secondaryButtonTextStyle = TextStyle(
    color: AppColors.colorPrimary,
    fontFamily: 'LexendDeca',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
}
