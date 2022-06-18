import 'package:flutter/cupertino.dart';

class CircleTransitionClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircleTransitionClipper(this.center, this.radius);

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
