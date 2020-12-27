import 'package:flutter/material.dart';

const textInputDecorationHome = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    errorStyle: TextStyle(fontSize: 14, height: 1.0, color: Color(0xffF79898)),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(15),
      ),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(15),
      ),
      borderSide: BorderSide(color: Color(0x99313c26), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          const Radius.circular(15),
        ),
        borderSide: BorderSide(color: Color(0xff313c26), width: 2)));

const textInputDecorationSignInAndSignIn = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    errorStyle: TextStyle(fontSize: 14, height: 1.0, color: Color(0xffF79898)),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(15),
      ),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(15),
      ),
      borderSide: BorderSide(color: Color(0xaa1e2128), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          const Radius.circular(15),
        ),
        borderSide: BorderSide(color: Color(0xff1e2128), width: 2)));

// class MyShapeBorder extends ContinuousRectangleBorder {
//   const MyShapeBorder(this.curveHeight);
//   final double curveHeight;

//   @override
//   Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
//     ..lineTo(0, rect.size.height + 60)
//     ..quadraticBezierTo(
//       0.0,
//       rect.size.height,
//       60,
//       rect.size.height,
//     )
//     ..lineTo(rect.size.width - 60, rect.size.height)
//     ..quadraticBezierTo(rect.size.width, rect.size.height, rect.size.width,
//         rect.size.height + 60)
//     ..lineTo(rect.size.width, 0)
//     ..close();
// }
