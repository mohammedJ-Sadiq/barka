import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/home/home.dart';
import 'package:barka/models/custom_phoneUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Provider.of<User>(context);
    print(_auth.currentUser);
    if (_auth.currentUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
