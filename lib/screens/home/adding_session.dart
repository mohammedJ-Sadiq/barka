import 'package:barka/models/user.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';
import 'package:barka/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final sessionRef = Firestore.instance.collection('sessions');

class AddingSession extends StatefulWidget {
  @override
  _AddingSessionState createState() => _AddingSessionState();
}

class _AddingSessionState extends State<AddingSession> {
  final _formKey = GlobalKey<FormState>();
  String _currentName;
  String _currentDescription;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: TextFormField(
              decoration:
                  textInputDecorationHome.copyWith(hintText: 'اسم الختمة'),
              validator: SessionNameValidator.validate,
              onChanged: (val) => setState(() => _currentName = val),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            decoration:
                textInputDecorationHome.copyWith(hintText: 'وصف الختمة'),
            onChanged: (val) => setState(() => _currentDescription = val),
          ),
          SizedBox(
            height: 59,
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
                  'بدأ ختمة',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () async {
              if (_formKey.currentState.validate()) {
                dynamic result = await DatabaseService(uid: user.uid)
                    .createNewSession(_currentName, _currentDescription);

                if (result == 'error') {
                  setState(() {
                    _error = "اسم هذه الختمة مأخوذ, الرجاء اختيار اسم آخر";
                  });
                  print(result);
                }
                if (result == null) {
                  print(result);
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
