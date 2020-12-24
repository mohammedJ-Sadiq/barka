import 'package:barka/models/chaptersTaken.dart';
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
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return MultiProvider(
        providers: [
          StreamProvider<List<Session>>.value(
            value: DatabaseService(uid: Provider.of<User>(context).uid).session,
          ),
          StreamProvider<List<ChaptersTaken>>.value(
            value: DatabaseService(uid: Provider.of<User>(context).uid)
                .chapterTaken,
          )
        ],
        child: Scaffold(
          key: _key,
          body: Container(
              color: Color(0xff1d2c26),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(right: width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: height * 0.23),
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
                        padding: EdgeInsets.only(right: width * 0.12),
                        child: logo(width, height),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: SessionList(),
                    height: height - height * 0.4,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.02),
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
