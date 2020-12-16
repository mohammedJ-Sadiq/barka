import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)));

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);
  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height + 60)
    ..quadraticBezierTo(
      0.0,
      rect.size.height,
      60,
      rect.size.height,
    )
    ..lineTo(rect.size.width - 60, rect.size.height)
    ..quadraticBezierTo(rect.size.width, rect.size.height, rect.size.width,
        rect.size.height + 60)
    ..lineTo(rect.size.width, 0)
    ..close();
}
