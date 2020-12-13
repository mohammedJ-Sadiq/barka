import 'package:barka/models/session.dart';
import 'package:flutter/material.dart';

class SessionTile extends StatelessWidget {
  final Session session;
  SessionTile({this.session});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green[200],
            backgroundImage: AssetImage('assets/alfateha.jpg'),
          ),
          title: Text(session.name),
          subtitle: Text(session.description),
        ),
      ),
    );
  }
}
