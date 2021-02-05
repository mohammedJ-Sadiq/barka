import 'package:barka/models/custom_user.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final sessionRef = FirebaseFirestore.instance.collection('sessions');

class AddingSession extends StatefulWidget {
  @override
  _AddingSessionState createState() => _AddingSessionState();
}

class _AddingSessionState extends State<AddingSession> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey0 = GlobalKey<FormState>();
  String _currentName;
  String _currentDescription;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _auth.currentUser.uid;
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey0,
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
                height: height * 0.02,
              ),
              TextFormField(
                decoration:
                    textInputDecorationHome.copyWith(hintText: 'اسم الختمة'),
                validator: SessionNameValidator.validate,
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                decoration:
                    textInputDecorationHome.copyWith(hintText: 'وصف الختمة'),
                onChanged: (val) => setState(() => _currentDescription = val),
              ),
              SizedBox(
                height: height * 0.02,
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
                      'بدأ ختمة',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: () async {
                  if (_formKey0.currentState.validate()) {
                    dynamic result = await DatabaseService(uid: currentUserUid)
                        .createNewSession(_currentName, _currentDescription);

                    if (result == 'error') {
                      setState(() {
                        _error = "اسم هذه الختمة مأخوذ, الرجاء اختيار اسم آخر";
                      });
                      print(result);
                    }
                    if (result == null) {
                      await DatabaseService(
                              uid: currentUserUid, name: _currentName)
                          .populateChaptersTakenWhenJoiningSession();
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              SizedBox(
                height: height * 0.01,
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
