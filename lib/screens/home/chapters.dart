import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/screens/home/chapter_list.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chapters extends StatelessWidget {
  final String name;
  Chapters({this.name});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ChapterAssignment>>.value(
      value: DatabaseService(name: name).chapter,
      child: Scaffold(
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
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Logo,
                    ),
                  ],
                ),
              ),
              Container(
                  child: ChapterList(),
                  height: 516,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ])),
      ),
    );
  }
}
