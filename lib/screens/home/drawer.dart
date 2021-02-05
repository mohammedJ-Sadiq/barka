import 'package:barka/models/custom_user.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/home/adding_session.dart';
import 'package:barka/screens/home/searching_session.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatefulWidget {
  final String userUid;
  MainDrawer({this.userUid});
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username = '';

  @override
  void initState() {
    super.initState();
    DatabaseService(uid: _auth.currentUser.uid)
        .getUsernameFromUid()
        .then((value) => setState(() {
              _username = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _auth.currentUser.uid;
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    void _showCreatingNewSessionModal() {
      showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.15, height * 0.06, width * 0.15, height * 0.5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey[900]),
                ),
                child: AddingSession(),
              ),
            );
          });
    }

    void _showSearchingForSessionModal() {
      showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.15, height * 0.06, width * 0.15, height * 0.5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green[800]),
                ),
                child: SearchingSession(),
              ),
            );
          });
    }

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: height * 0.339,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: AssetImage('assets/quran_reader.jpeg'),
                    fit: BoxFit.fill),
              ),
              width: width,
              padding: EdgeInsets.fromLTRB(
                  width * 0.04, 0, width * 0.04, height * 0.028),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.64, height * 0.006, 0, height * 0.18),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // todo
                        // updaing the name function
                      },
                    ),
                  ),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown[900]),
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Center(
                      child: Text(
                        _username,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.02, height * 0.04, width * 0.02, height * 0.01),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.add_circle,
                      color: Colors.blueGrey[900],
                      size: 40,
                    ),
                    title: Text(
                      'إضافة ختمة جديدة',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      _showCreatingNewSessionModal();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.03),
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.green[800],
                        size: 40,
                      ),
                      title: Text(
                        'البحث عن ختمة',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        _showSearchingForSessionModal();
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.26,
                  ),
                  Divider(
                    color: Colors.brown,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                    ),
                    title: Text(
                      'تسجيل خروج',
                      style: TextStyle(fontSize: 17),
                    ),
                    onTap: () async {
                      await _auth.signOut();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
