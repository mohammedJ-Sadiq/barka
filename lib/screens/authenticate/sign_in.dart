import 'package:barka/services/auth.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:barka/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
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
                      decoration: textInputDecorationSignInAndSignIn.copyWith(
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
                      height: height * 0.04,
                    ),
                    TextFormField(
                      decoration: textInputDecorationSignInAndSignIn.copyWith(
                          hintText: 'كلمة المرور',
                          hintStyle: TextStyle(
                              fontSize: 16, fontFamily: 'Amiri', height: 1.0)),
                      validator: PasswordValidator.validate,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: height * 0.13,
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
                              'تسجيل الدخول',
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
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    'Could not sign in with those credentials';
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
                          'ليس لديك حساب مسبق, ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        GestureDetector(
                            child: Text(
                              'تسجيل جديد',
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
      ),
    );
  }
}
