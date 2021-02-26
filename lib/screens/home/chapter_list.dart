import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/home/chapter_tile.dart';
import 'package:barka/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference readerCollection =
    FirebaseFirestore.instance.collection('readers');

class ChapterList extends StatefulWidget {
  final String sessionName;
  int noOfChaptersTaken;
  int noOfChaptersFinished;
  ChapterList(
      {this.sessionName, this.noOfChaptersTaken, this.noOfChaptersFinished});
  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  @override
  Widget build(BuildContext context) {
    final currentUserUid = Provider.of<CustomUser>(context).uid;
    String _username = Provider.of<CustomUser>(context).name;
    final chapters = Provider.of<List<ChapterAssignment>>(context) ?? [];

    // Future<void> updateName() async {
    //   await DatabaseService(uid: currentUserUid)
    //       .getUsernameFromUid()
    //       .then((value) => setState(() {
    //             _username = value;
    //           }));
    // }

    return ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                String chapterUid = chapters[index].uid;
                if (chapterUid == '') {
                  setState(() {
                    chapters[index].uid = currentUserUid;
                    chapters[index].name = _username;
                  });
                  print(widget.noOfChaptersTaken);
                  await DatabaseService(name: widget.sessionName)
                      .updateChapterAssignmentUsername(chapters);
                  await DatabaseService(name: widget.sessionName)
                      .updateNoOfChaptersTaken();
                  await DatabaseService(
                          uid: currentUserUid, name: widget.sessionName)
                      .updateNoOfChaptersTakenForAUser(true);
                } else {
                  if (chapterUid == currentUserUid &&
                      chapters[index].chapterStatus == false) {
                    setState(() {
                      chapters[index].uid = '';
                      chapters[index].name = '';
                    });
                    print(widget.noOfChaptersTaken);
                    await DatabaseService(name: widget.sessionName)
                        .updateChapterAssignmentUsername(chapters);
                    await DatabaseService(name: widget.sessionName)
                        .updateNoOfChaptersTaken();
                    await DatabaseService(
                            uid: currentUserUid, name: widget.sessionName)
                        .updateNoOfChaptersTakenForAUser(false);
                  }
                }
              },
              child: ChapterTile(
                chapter: chapters[index],
                sessionName: widget.sessionName,
                noOfChaptersFinished: widget.noOfChaptersFinished,
              ));
        });
  }
}
