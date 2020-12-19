import 'package:barka/models/session.dart';
import 'package:barka/models/user.dart';
import 'package:barka/screens/home/drawer.dart';
import 'package:barka/screens/home/session_list.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldState> _key = GlobalKey();

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Session>>.value(
        value: DatabaseService(uid: Provider.of<User>(context).uid).session,
        child: Scaffold(
          key: _key,
          body: Container(
              color: Color(0xff1d2c26),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 185),
                        child: InkWell(
                          onTap: () {
                            _key.currentState.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Logo,
                      ),
                    ],
                  ),
                ),
                Container(
                    child: SessionList(),
                    height: 516,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
              ])),
          drawer: MainDrawer(
            userUid: Provider.of<User>(context).uid,
          ),
        ));
  }
}
