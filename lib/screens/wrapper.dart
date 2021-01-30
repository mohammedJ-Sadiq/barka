import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/home/home.dart';
import 'package:barka/models/custom_phoneUser.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
