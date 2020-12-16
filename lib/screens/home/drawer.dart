import 'package:barka/models/user.dart';
import 'package:barka/screens/home/adding_session.dart';
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

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('assets/quran_reader.jpeg'),
                  fit: BoxFit.fill),
            ),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 140, 20, 20),
            // color: Colors.brown[200],
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 0),
              // color: Colors.white.withOpacity(0.5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown[900].withOpacity(0.7)),
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Text(
                    _username,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.add_circle,
              color: Colors.cyan[300],
              size: 40,
            ),
            title: Text('إضافة ختمة جديدة'),
            onTap: () {
              _showCreatingNewSessionModal();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'profile',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
