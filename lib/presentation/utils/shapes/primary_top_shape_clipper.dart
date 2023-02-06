import 'package:flutter/material.dart';

class PrimaryTopShapeClipper extends CustomClipper<Path> {
  final double verticalOffset;
  PrimaryTopShapeClipper({
    required this.verticalOffset,
  });
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - verticalOffset);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - verticalOffset,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
