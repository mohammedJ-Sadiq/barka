import 'package:barka/models/session.dart';
import 'package:barka/models/user.dart';
import 'package:barka/screens/home/drawer.dart';
import 'package:barka/screens/home/session_list.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Session>>.value(
        value: DatabaseService(uid: Provider.of<User>(context).uid).session,
        child: Scaffold(
          appBar: AppBar(
            shape: MyShapeBorder(20),
            toolbarHeight: 160,
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.green[400],
            title: Text(
              "بركة",
              style: TextStyle(fontSize: 52, fontFamily: 'Aref'),
            ),
          ),
          drawer: MainDrawer(
            userUid: Provider.of<User>(context).uid,
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/holly_symbols.png'),
                    fit: BoxFit.cover)),
            child: SessionList(),
          ),
        ));
  }
}
