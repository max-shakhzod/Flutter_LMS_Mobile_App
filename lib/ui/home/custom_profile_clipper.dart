import 'package:flutter/material.dart';

class CustomProfileClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height - 15, size.width / 2, size.height);
    path.quadraticBezierTo(size.width / 2, size.height, size.width / 4 * 3, size.height - 15);
    path.quadraticBezierTo(size.width / 4 * 3, size.height - 15, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }

}