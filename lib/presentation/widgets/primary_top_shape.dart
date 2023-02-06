import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/shapes/primary_top_shape_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTopShape extends StatelessWidget {
  const PrimaryTopShape({
    Key? key,
    required this.child,
    required this.height,
  }) : super(key: key);
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PrimaryTopShapeClipper(
        verticalOffset: 40.h,
      ),
      child: Container(
        color: AppColors.colorPrimary,
        height: height,
        child: child,
      ),
    );
  }
}
