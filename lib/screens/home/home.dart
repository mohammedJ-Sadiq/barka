import 'package:barka/models/chaptersTaken.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/models/session.dart';
import 'package:barka/models/custom_user.dart';
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

    String _calculateNoOfAllChaptersTaken(List<ChaptersTaken> chaptersTaken) {
      try {
        int total = 0;
        print(chaptersTaken.length);
        for (var i = 0; i < chaptersTaken.length; i++) {
          total = total + chaptersTaken[i].noOfChaptersTaken;
        }
        switch (total) {
          case 0:
            return '$total من الأجزاء';
            break;
          case 1:
            return 'جزء واحد';
            break;
          case 2:
            return 'جزئين';
            break;
          case 3:
          case 4:
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 10:
            return '$total أجزاء';
            break;

          default:
            return '$total  جزء';
        }
      } catch (e) {
        print(e.toString());
      }
      return '';
    }

    return MultiProvider(
        providers: [
          StreamProvider<List<Session>>.value(
            value: DatabaseService(uid: Provider.of<CustomUser>(context).uid)
                .session,
          ),
          StreamProvider<List<ChaptersTaken>>.value(
            value: DatabaseService(uid: Provider.of<CustomUser>(context).uid)
                .chapterTaken,
          )
        ],
        child: StreamBuilder<List<ChaptersTaken>>(
            stream: DatabaseService(uid: Provider.of<CustomUser>(context).uid)
                    .chapterTaken ??
                [],
            builder: (context, snapshot) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0.0, height * 0.30, width * 0.04, 0.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      'عليك:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Amiri',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      _calculateNoOfAllChaptersTaken(
                                          snapshot.data),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Amiri'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          child: SessionList(),
                          height: height - height * 0.4,
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.02),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                    ])),
                drawer: MainDrawer(
                  userUid: Provider.of<CustomUser>(context).uid,
                ),
              );
            }));
  }
}
