import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SnackBars {
  static void sucessMessageSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.colorTextGreen,
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.colorWhite,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void errorMessageSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textColorRed,
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.colorWhite,
          ),
        ),
        // action: SnackBarAction(
        //   label: 'Ok',
        //   textColor: AppColors.colorWhite,
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
