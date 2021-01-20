import 'package:barka/shared/constants.dart';
import 'package:barka/shared/loading.dart';
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

  String _translateDatabaseErrorMsgToArabic(String databaseErrorMsg) {
    String errorMsg1 = 'The email address is badly formatted.';
    String errorMsg2 =
        'The email address is already in use by another account.';

    if (databaseErrorMsg == errorMsg1) {
      return 'صيغة البريد الألكتروني خاطئة, الرجاء التأكد من البريد الألكتروني.';
    }
    if (databaseErrorMsg == errorMsg2) {
      return 'البريد الألكتروني المدخل مسجل لحساب آخر';
    }

    return '';
  }

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
                            height: height * 0.02,
                          ),
                          TextFormField(
                            decoration:
                                textInputDecorationSignInAndSignIn.copyWith(
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
                            height: height * 0.02,
                          ),
                          TextFormField(
                            decoration:
                                textInputDecorationSignInAndSignIn.copyWith(
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
                            height: height * 0.04,
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
                                  if (result is String) {
                                    setState(() {
                                      error =
                                          _translateDatabaseErrorMsgToArabic(
                                              result);
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                          SizedBox(
                            height: height * 0.02,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
          );
  }
}
