import 'package:barka/models/chaptersTaken.dart';
import 'package:barka/models/session.dart';
import 'package:flutter/material.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  final ChaptersTaken chaptersTaken;
  SessionTile({this.session, this.chaptersTaken});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Container(
      height: 75,
      margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.01, width * 0.05, 0),
      child: Card(
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
                  child: Text(session.name),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, left: 0),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff937b4c),
                    ),
                    child: Text(
                      '${chaptersTaken.noOfChaptersTaken}',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      session.description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      child: Text('${session.noOfChaptersTaken}'),
                      width: width / 3,
                    ),
                  ),
                  Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: height * 0.004,
              width: (width - (width * 0.15)) *
                  (session.noOfChaptersFinished / 30),
              color: Colors.green[800],
            )
          ],
        ),
      ),
    );
  }
}
