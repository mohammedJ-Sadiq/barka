import 'package:barka/models/session.dart';
import 'package:barka/models/user.dart';
import 'package:barka/screens/home/adding_session.dart';
import 'package:barka/screens/home/searching_session.dart';
import 'package:barka/screens/home/session_list.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    void _showCreatingNewSessionModal() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: AddingSession(),
            );
          });
    }

    void _showSearchingForSessionModal() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SearchingSession(),
            );
          });
    }

    return StreamProvider<List<Session>>.value(
      value: DatabaseService(uid: Provider.of<User>(context).uid).session,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 35,
            ),
            tooltip: 'ختمة جديدة',
            onPressed: () {
              _showCreatingNewSessionModal();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.green[400],
          title: Text(
            "بركة",
            style: TextStyle(fontSize: 38, fontFamily: 'Aref'),
          ),
          actions: [
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('تسجيل خروج')),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/holly_symbols.png'),
                  fit: BoxFit.cover)),
          child: SessionList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.search,
            size: 38,
          ),
          backgroundColor: Colors.green[500],
          onPressed: () {
            _showSearchingForSessionModal();
          },
        ),
      ),
    );
  }
}
