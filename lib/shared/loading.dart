import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Container(
        color: Color(0xff1d2c26),
        child: Column(
          children: [
            logo(width, height),
            SizedBox(
              height: height * 0.1,
            ),
            Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 60.0,
              ),
            ),
          ],
        ));
  }
}
