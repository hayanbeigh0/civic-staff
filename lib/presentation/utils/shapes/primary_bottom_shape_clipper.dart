import 'package:flutter/material.dart';

class PrimaryBottomShapeClipper extends CustomClipper<Path> {
  final double varticalOffset;
  PrimaryBottomShapeClipper({
    required this.varticalOffset,
  });
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, varticalOffset);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, varticalOffset);
    path.quadraticBezierTo(
      size.width / 2,
      0,
      0,
      varticalOffset,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
