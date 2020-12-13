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
  String _error;
  String _currentName;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future<bool> searchingForNameMatching(String name) async {
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
          Text(
            'للبحث عن ختمة معينة عن طريق الاسم',
            style: TextStyle(color: Colors.green[400]),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: SessionNameValidator.validate,
            decoration: textInputDecoration.copyWith(hintText: 'اسم الختمة'),
            onChanged: (val) => setState(() => _currentName = val),
          ),
          SizedBox(
            height: 16,
          ),
          RaisedButton(
            color: Colors.green[600],
            child: Text(
              'انضم للختمة',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                bool result = await searchingForNameMatching(_currentName);

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
