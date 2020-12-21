import 'package:flutter/material.dart';

Widget logo(double width, double height) {
  return Padding(
    padding: EdgeInsets.only(top: height * 0.02),
    child: Container(
        height: height * 0.38,
        width: width * 0.55,
        color: Colors.transparent,
        padding: EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/islamic_appbar_2.png'),
                  fit: BoxFit.scaleDown)),
        )),
  );
}
