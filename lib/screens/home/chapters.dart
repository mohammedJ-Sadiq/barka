import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/screens/home/chapter_list.dart';
import 'package:barka/services/database.dart';
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
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green[400],
          title: Text(
            "بركة",
            style: TextStyle(fontSize: 38, fontFamily: 'Aref'),
          ),
          actions: [],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/holly_symbols.png'),
                    fit: BoxFit.cover)),
            child: ChapterList(sessionName: name)),
      ),
    );
  }
}
