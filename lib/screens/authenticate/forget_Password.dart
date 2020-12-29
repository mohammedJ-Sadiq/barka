import 'dart:async';
import 'package:barka/services/auth.dart';
import 'package:barka/shared/constants.dart';
import 'package:barka/shared/logo.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String error = '';

  String _translateDatabaseErrorMsgToArabic(String databaseErrorMsg) {
    String errorMsg1 = 'The email address is badly formatted.';
    String errorMsg2 =
        'There is no user record corresponding to this identifier. The user may have been deleted.';
    String errorMsg3 =
        'We have blocked all requests from this device due to unusual activity. Try again later.';

    if (databaseErrorMsg == errorMsg1) {
      return 'صيغة البريد الألكتروني خاطئة, الرجاء التأكد من البريد الألكتروني.';
    }
    if (databaseErrorMsg == errorMsg2) {
      return 'البريد الألكتروني المدخل غير مسجل, الرجاء التأكد من البريد الألكتروني, أو قم بإنشاء حساب جديد.';
    }
    if (databaseErrorMsg == errorMsg3) {
      return 'تم حظر هذا الجهاز بسبب ملاحظة بعض الأنشطة الغير طبيعية, الرجاء المحاولة مرة أخرى لاحقا.';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        color: Color(0xff333748),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: EdgeInsets.only(bottom: height * 0.23),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.12),
                  child: logo(width, height),
                ),
              ]),
            ),
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
                      decoration: textInputDecorationSignInAndSignIn.copyWith(
                          counterText: '',
                          hintText: 'البريد الإلكتروني',
                          hintStyle: TextStyle(
                              fontSize: 16, fontFamily: 'Amiri', height: 1.0)),
                      validator: EmailValidator.validate,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: height * 0.23,
                    ),
                    GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: width - width * 0.1,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff937b4c),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'إرسال',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() {});
                            dynamic result =
                                await _auth.sendPasswordResetEmail(email);

                            if (result is String) {
                              setState(() {
                                error =
                                    _translateDatabaseErrorMsgToArabic(result);
                              });
                            } else {
                              Flushbar(
                                message:
                                    'تم إرسال رابط إعادة تعيين كلمة المرور  $email',
                                duration: Duration(seconds: 3),
                                isDismissible: true,
                                mainButton: FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )..show(context);
                              Timer(Duration(seconds: 5), () {
                                Navigator.of(context).pop();
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
