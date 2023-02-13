// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class LoginShapeBottom extends StatelessWidget {
  const LoginShapeBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          ClipPath(
            clipper: ShapeClipper(
              leftHorizontallOffset: constraints.maxWidth > 600 ? 0.w : 60.w,
              rightVerticalOffset: 10.h,
              curvatureHeight: 5.h,
              curvatureWidth: constraints.maxWidth > 600 ? 0.5.w : 1.5.w,
            ),
            child: Container(
              color: AppColors.colorPrimary,
              height: 70.h,
              width: double.infinity,
            ),
          ),
          ClipPath(
            clipper: ShapeClipper(
              leftHorizontallOffset: constraints.maxWidth > 600 ? -50.w : 0.w,
              rightVerticalOffset: constraints.maxWidth > 600 ? 20.h : 18.h,
              curvatureHeight: 25.h,
              curvatureWidth: constraints.maxWidth > 600 ? 0.45.w : 1.4.w,
            ),
            child: Container(
              color: AppColors.colorPrimaryExtraLight,
              height: 70.h,
              width: double.infinity,
            ),
          ),
        ],
      );
    });
  }
}

class ShapeClipper extends CustomClipper<Path> {
  final double leftHorizontallOffset;
  final double rightVerticalOffset;
  double curvatureHeight;
  double curvatureWidth;

  ShapeClipper({
    required this.leftHorizontallOffset,
    required this.rightVerticalOffset,
    this.curvatureHeight = 0,
    this.curvatureWidth = 1.6,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(
      (size.width / 2),
      size.height,
    );
    path.lineTo(
      size.width,
      size.height,
    );
    path.lineTo(
      size.width,
      0 + rightVerticalOffset,
    );
    path.quadraticBezierTo(
      size.width / curvatureWidth,
      curvatureHeight,
      size.width / 2 - leftHorizontallOffset,
      size.height,
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
