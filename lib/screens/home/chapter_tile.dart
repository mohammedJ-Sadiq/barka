import 'package:barka/models/chapter_assignment.dart';
import 'package:flutter/material.dart';

class ChapterTile extends StatelessWidget {
  final ChapterAssignment chapter;
  ChapterTile({this.chapter});
  @override
  Widget build(BuildContext context) {
    print(chapter.chapterNo);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          title: Text(
            "الجزء   ${chapter.chapterNo}",
            style: TextStyle(fontSize: 24, fontFamily: 'Amiri'),
          ),
          subtitle: Text(chapter.uid),
        ),
      ),
    );
  }
}
