import 'package:flutter/material.dart';

var Logo = Container(
    height: 300,
    width: 220,
    color: Colors.transparent,
    padding: EdgeInsets.only(top: 10),
    child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/islamic_appbar_2.png'),
              fit: BoxFit.scaleDown)),
    ));
