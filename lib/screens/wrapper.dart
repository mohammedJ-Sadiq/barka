import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/home/home.dart';
import 'package:barka/models/custom_phoneUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barka/shared/loading.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Loading();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CustomUser currentUser = Provider.of<CustomUser>(context);
    print(_auth.currentUser);
    if (currentUser == null) {
      return Authenticate();
    } else if (currentUser.name == '') {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
