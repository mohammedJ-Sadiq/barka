import 'package:barka/models/session.dart';
import 'package:barka/models/user.dart';
import 'package:barka/screens/home/adding_session.dart';
import 'package:barka/screens/home/drawer.dart';
import 'package:barka/screens/home/searching_session.dart';
import 'package:barka/screens/home/session_list.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
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
            shape: MyShapeBorder(20),
            toolbarHeight: 160,
            elevation: 7,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.green[400],
            title: Text(
              "بركة",
              style: TextStyle(fontSize: 52, fontFamily: 'Aref'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 50.0),
                child: IconButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 45,
                  ),
                ),
              ),
            ],
          ),
          drawer: MainDrawer(
            userUid: Provider.of<User>(context).uid,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         FlatButton.icon(
            //           icon: Icon(
            //             Icons.add_circle,
            //             color: Colors.cyan[300],
            //             size: 40,
            //           ),
            //           label: Text('إضافة ختمة جديدة'),
            //           onPressed: () {
            //             _showCreatingNewSessionModal();
            //           },
            //         ),
            //         IconButton(
            //             icon: Icon(
            //               Icons.search,
            //               size: 40,
            //             ),
            //             onPressed: () {
            //               _showSearchingForSessionModal();
            //             }),
            //         IconButton(
            //             icon: Icon(
            //               Icons.settings,
            //               size: 40,
            //             ),
            //             onPressed: () {
            //               _showSearchingForSessionModal();
            //             }),
            //       ],
            //     ),
            //   ),
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
        ));
  }
}
