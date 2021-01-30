import 'package:flutter/material.dart';
import 'package:barka/shared/loading.dart';
import 'package:barka/shared/logo.dart';
import 'package:barka/shared/constants.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/services/database.dart';

class CreateUsernameForPhoneuser extends StatefulWidget {
  String uid;
  String phoneNumber;

  CreateUsernameForPhoneuser({this.uid, this.phoneNumber});
  @override
  _CreateUsernameForPhoneuserState createState() =>
      _CreateUsernameForPhoneuserState();
}

class _CreateUsernameForPhoneuserState
    extends State<CreateUsernameForPhoneuser> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String name = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: Color(0xff333748),
              child: Column(
                children: [
                  logo(width, height),
                  Container(
                    width: width,
                    height: height - height * 0.4,
                    padding: EdgeInsets.fromLTRB(
                        width * 0.1, height * 0.05, width * 0.1, height * 0.05),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                textInputDecorationSignInAndSignIn.copyWith(
                                    hintText: 'الأسم الكامل',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Amiri',
                                        height: 1.0)),
                            validator: NameValidator.validate,
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 30,
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xff937b4c),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'تسجيل',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await DatabaseService(uid: widget.uid)
                                      .createUserData(name, widget.phoneNumber);

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              width: double.infinity,
              height: 900,
            ),
          );
  }
}
