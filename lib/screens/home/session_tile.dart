import 'package:barka/models/session.dart';
import 'package:flutter/material.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  SessionTile({this.session});
  @override
  Widget build(BuildContext context) {
    //print(session.name);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Card(
          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Container(
            height: 60,
            width: 400,
            child: Text(session.name),
          )),
    );
  }
}
