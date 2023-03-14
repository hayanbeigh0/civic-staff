// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

class LoginShapeTop extends StatelessWidget {
  const LoginShapeTop({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: ShapeClipper(
            leftVerticalOffset: 20.h,
            rightVerticalOffset: 150.h,
          ),
          child: Container(
            color: AppColors.colorSecondary,
            height: 300.h,
            width: double.infinity,
          ),
        ),
        ClipPath(
          clipper: ShapeClipper(
            leftVerticalOffset: 25.h,
            rightVerticalOffset: 190.h,
          ),
          child: Container(
            color: AppColors.colorPrimary,
            height: 300.h,
            width: double.infinity,
            child: child,
          ),
        ),
      ],
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  final double leftVerticalOffset;
  final double rightVerticalOffset;

  ShapeClipper({
    required this.leftVerticalOffset,
    required this.rightVerticalOffset,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - leftVerticalOffset);
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - rightVerticalOffset);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
