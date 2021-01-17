import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterTile extends StatefulWidget {
  final ChapterAssignment chapter;
  final String sessionName;
  int noOfChaptersFinished;
  ChapterTile({this.chapter, this.sessionName, this.noOfChaptersFinished});

  @override
  _ChapterTileState createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  @override
  Widget build(BuildContext context) {
    // int _noOfChaptersFinished = widget.noOfChaptersFinished;
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    if (widget.chapter.uid == '') {
      return Padding(
        padding: EdgeInsets.only(top: height * 0.01),
        child: Card(
          elevation: 0.0,
          margin: EdgeInsets.fromLTRB(
              width * 0.02, height * 0.005, width * 0.02, 0),
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
          padding: EdgeInsets.only(top: height * 0.01),
          child: Card(
            shadowColor: Colors.green[300],
            elevation: 3.0,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(
                width * 0.02, height * 0.005, width * 0.02, 0),
            child: ListTile(
              trailing: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: IconButton(
                  icon: Icon(
                    Icons.check_box,
                    size: 35,
                    color: Colors.green[800],
                  ),
                  onPressed: () async {
                    if (widget.chapter.uid ==
                        Provider.of<CustomUser>(context, listen: false).uid) {
                      print(widget.noOfChaptersFinished);
                      setState(() {
                        widget.chapter.chapterStatus =
                            !widget.chapter.chapterStatus;
                        widget.noOfChaptersFinished--;
                      });
                      print(widget.noOfChaptersFinished);
                      await DatabaseService(name: widget.sessionName)
                          .updateChapterAssignmentChapterStatus(widget.chapter);
                      await DatabaseService(name: widget.sessionName)
                          .updateNoOfChaptersFinished();
                      await DatabaseService(
                              name: widget.sessionName,
                              uid: Provider.of<CustomUser>(context,
                                      listen: false)
                                  .uid)
                          .updateNoOfChaptersTakenForAUserWhenMarkedFinished(
                              false);
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
          padding: EdgeInsets.only(top: height * 0.01),
          child: Card(
            shadowColor: Colors.grey[300],
            elevation: 3.0,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(
                width * 0.02, height * 0.005, width * 0.02, 0),
            child: ListTile(
              trailing: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: IconButton(
                  icon: Icon(
                    Icons.check_box_outline_blank,
                    size: 35,
                  ),
                  onPressed: () async {
                    if (widget.chapter.uid ==
                        Provider.of<CustomUser>(context, listen: false).uid) {
                      setState(() {
                        widget.chapter.chapterStatus =
                            !widget.chapter.chapterStatus;
                      });

                      await DatabaseService(name: widget.sessionName)
                          .updateChapterAssignmentChapterStatus(widget.chapter);
                      await DatabaseService(name: widget.sessionName)
                          .updateNoOfChaptersFinished();
                      await DatabaseService(
                              name: widget.sessionName,
                              uid: Provider.of<CustomUser>(context,
                                      listen: false)
                                  .uid)
                          .updateNoOfChaptersTakenForAUserWhenMarkedFinished(
                              true);
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
