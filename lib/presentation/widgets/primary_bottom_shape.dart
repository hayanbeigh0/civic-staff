import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/shapes/primary_bottom_shape_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryBottomShape extends StatelessWidget {
  final double height;
  const PrimaryBottomShape({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PrimaryBottomShapeClipper(varticalOffset: 40.h),
      child: Container(
        color: AppColors.colorPrimary,
        height: height,
      ),
    );
  }
}
