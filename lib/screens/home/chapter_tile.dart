import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/models/user.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterTile extends StatefulWidget {
  final ChapterAssignment chapter;
  final String sessionName;
  ChapterTile({this.chapter, this.sessionName});

  @override
  _ChapterTileState createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.chapter.uid == '') {
      return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            title: Text(
              "الجزء   ${widget.chapter.chapterNo}",
              style: TextStyle(fontSize: 24, fontFamily: 'Amiri'),
            ),
            subtitle: Text(widget.chapter.name),
          ),
        ),
      );
    } else {
      if (widget.chapter.chapterStatus) {
        return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            shadowColor: Colors.green[300],
            elevation: 3.0,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    size: 35,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    if (widget.chapter.uid ==
                        Provider.of<User>(context, listen: false).uid) {
                      setState(() {
                        widget.chapter.chapterStatus =
                            !widget.chapter.chapterStatus;
                      });
                      await DatabaseService(name: widget.sessionName)
                          .updateChapterAssignmentChapterStatus(widget.chapter);
                    }
                  },
                ),
              ),
              title: Text(
                "الجزء   ${widget.chapter.chapterNo}",
                style: TextStyle(fontSize: 24, fontFamily: 'Amiri'),
              ),
              subtitle: Text(widget.chapter.name),
            ),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            shadowColor: Colors.grey[300],
            elevation: 3.0,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    size: 35,
                  ),
                  onPressed: () async {
                    if (widget.chapter.uid ==
                        Provider.of<User>(context, listen: false).uid) {
                      setState(() {
                        widget.chapter.chapterStatus =
                            !widget.chapter.chapterStatus;
                      });
                      await DatabaseService(name: widget.sessionName)
                          .updateChapterAssignmentChapterStatus(widget.chapter);
                    }
                  },
                ),
              ),
              title: Text(
                "الجزء   ${widget.chapter.chapterNo}",
                style: TextStyle(fontSize: 24, fontFamily: 'Amiri'),
              ),
              subtitle: Text(widget.chapter.name),
            ),
          ),
        );
      }
    }
  }
}
