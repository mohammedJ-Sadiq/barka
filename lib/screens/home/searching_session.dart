import 'package:barka/models/user.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final sessionRef = Firestore.instance.collection('sessions');

class SearchingSession extends StatefulWidget {
  @override
  _SearchingSessionState createState() => _SearchingSessionState();
}

class _SearchingSessionState extends State<SearchingSession> {
  bool _validate = true;
  String _error = '';
  String _currentName;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future<bool> joiningSession(String name) async {
      DocumentSnapshot doc = await sessionRef.document(name).get();
      if (doc.exists) {
        DatabaseService(uid: user.uid, name: name).joinSession(
            doc.data['name'],
            doc.data['description'],
            doc.data['creator'],
            doc.data['available_chapters'],
            List.from(doc.data['readers']));
      } else {
        _validate = false;
      }
      return _validate;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: TextFormField(
              validator: SessionNameValidator.validate,
              decoration:
                  textInputDecorationHome.copyWith(hintText: 'اسم الختمة'),
              onChanged: (val) => setState(() => _currentName = val),
            ),
          ),
          SizedBox(
            height: 120,
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 330,
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
              if (_formKey.currentState.validate()) {
                bool result = await joiningSession(_currentName);

                if (result == false) {
                  setState(() {
                    _error = "لاتوجد ختمة بهذا الأسم";
                  });
                } else {
                  Navigator.pop(context);
                }
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            _error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
