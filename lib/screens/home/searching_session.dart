import 'package:barka/models/custom_user.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final sessionRef = FirebaseFirestore.instance.collection('sessions');

class SearchingSession extends StatefulWidget {
  @override
  _SearchingSessionState createState() => _SearchingSessionState();
}

class _SearchingSessionState extends State<SearchingSession> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _validate = true;
  String _error = '';
  String _currentName;
  int _currentOrderNum;
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    final user = _auth.currentUser;

    Future<bool> joiningSession(String name) async {
      DocumentSnapshot doc = await sessionRef.doc(name).get();
      if (doc.exists) {
        DatabaseService(uid: user.uid, name: name).joinSession(
            doc.data()['name'],
            doc.data()['description'],
            doc.data()['creator'],
            doc.data()['available_chapters'],
            List.from(doc.data()['readers']),
            doc.data()['no_of_chapters_taken'],
            doc.data()['no_of_chapters_finished'],
            doc.data()['order']);
      } else {
        _validate = false;
      }
      return _validate;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey1,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              width * 0.04, height * 0.02, width * 0.04, 0.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: width * 0.55),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              TextFormField(
                validator: SessionNameValidator.validate,
                decoration:
                    textInputDecorationHome.copyWith(hintText: 'اسم الختمة'),
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff937b4c),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'الانضمام للختمة',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: () async {
                  if (_formKey1.currentState.validate()) {
                    bool result = await joiningSession(_currentName);

                    if (result == false) {
                      setState(() {
                        _error = "لاتوجد ختمة بهذا الأسم";
                      });
                    } else {
                      await DatabaseService(uid: user.uid, name: _currentName)
                          .populateChaptersTakenWhenJoiningSession();
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                _error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
