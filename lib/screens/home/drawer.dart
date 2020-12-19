import 'package:barka/models/user.dart';
import 'package:barka/screens/home/adding_session.dart';
import 'package:barka/screens/home/searching_session.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  final String userUid;
  MainDrawer({this.userUid});
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _username = '';
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    DatabaseService(uid: Provider.of<User>(context, listen: false).uid)
        .getUsernameFromUid()
        .then((value) => setState(() {
              _username = value;
            }));
  }

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

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('assets/quran_reader.jpeg'),
                  fit: BoxFit.fill),
            ),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(262, 5, 0, 200),
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
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 0),
                  // color: Colors.white.withOpacity(0.5),
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
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Column(
              children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.cyan[300],
                      size: 40,
                    ),
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
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.green[400],
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
                  height: 292,
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
    );
  }
}
