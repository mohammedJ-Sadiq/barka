import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/screens/home/chapter_list.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chapters extends StatelessWidget {
  final String name;
  final int noOfChaptersTaken;
  final int noOfChaptersFinished;
  Chapters({this.name, this.noOfChaptersTaken, this.noOfChaptersFinished});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return StreamProvider<List<ChapterAssignment>>.value(
      value: DatabaseService(name: name).chapter,
      child: Scaffold(
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
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
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
                      padding: EdgeInsets.only(right: width * 0.10),
                      child: Container(
                        padding: EdgeInsets.only(bottom: height * 0.23),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => new CupertinoAlertDialog(
                                      title: new Text('إعادة الختمة'),
                                      content:
                                          new Text("متأكد من إعادة الختمة؟!"),
                                      actions: [
                                        FlatButton(
                                          child: Text(
                                            'نعم',
                                            style: TextStyle(
                                                color: Colors.red[800]),
                                          ),
                                          onPressed: () async {
                                            await DatabaseService(name: name)
                                                .resetChapterAssignmentPage();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('لأ'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                          },
                          child: Icon(
                            Icons.settings_backup_restore,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  child: ChapterList(
                    sessionName: name,
                    noOfChaptersTaken: noOfChaptersTaken,
                    noOfChaptersFinished: noOfChaptersFinished,
                  ),
                  height: height - height * 0.4,
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: 0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ])),
      ),
    );
  }
}
