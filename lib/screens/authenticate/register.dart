import 'package:barka/shared/constants.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:barka/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff333748),
          child: Column(
            children: [
              Logo,
              Container(
                height: 600,
                padding: EdgeInsets.fromLTRB(50, 60, 50, 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecorationSignInAndSignIn.copyWith(
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
                        height: 25.0,
                      ),
                      TextFormField(
                        decoration: textInputDecorationSignInAndSignIn.copyWith(
                            hintText: 'البريد الإلكتروني',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Amiri',
                                height: 1.0)),
                        validator: EmailValidator.validate,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        decoration: textInputDecorationSignInAndSignIn.copyWith(
                            hintText: 'كلمة المرور',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Amiri',
                                height: 1.0)),
                        validator: PasswordValidator.validate,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 50.0,
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
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, name);
                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب مسبق, ',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          GestureDetector(
                              child: Text(
                                'تسجيل دخول',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                widget.toggleView();
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          width: double.infinity,
          height: 900,
        ),
      ),
    );
  }
}
