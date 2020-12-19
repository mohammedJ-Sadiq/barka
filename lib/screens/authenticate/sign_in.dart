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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff333748),
          child: Column(
            children: [
              // Image.asset('assets/islamic_motifs.jpg'),
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
                        height: 98.0,
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
          width: double.infinity,
          height: 900,
        ),
      ),
      // body: Container(
      //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      //   child: Form(
      //     key: _formkey,
      //     child: Column(
      //       children: [
      //         SizedBox(height: 20.0),
      //         TextFormField(
      //           decoration: textInputDecoration.copyWith(hintText: 'Email'),
      //           validator: (val) => val.isEmpty ? 'Enter an email' : null,
      //           onChanged: (val) {
      //             setState(() {
      //               email = val;
      //             });
      //           },
      //         ),
      //         SizedBox(height: 20.0),
      //         TextFormField(
      //           decoration: textInputDecoration.copyWith(hintText: 'Password'),
      //           validator: (val) =>
      //               val.length < 6 ? 'Enter a password 6+ chars  long' : null,
      //           obscureText: true,
      //           onChanged: (val) {
      //             setState(() {
      //               password = val;
      //             });
      //           },
      //         ),
      //         SizedBox(height: 20.0),
      //         RaisedButton(
      //           onPressed: () async {
      //             if (_formkey.currentState.validate()) {
      //               setState(() {
      //                 loading = true;
      //               });
      //               dynamic result =
      //                   await _auth.signInWithEmailAndPassword(email, password);
      //               if (result == null) {
      //                 setState(() {
      //                   error = 'Could not sign in with those credentials';
      //                   loading = false;
      //                 });
      //               }
      //             }
      //           },
      //           color: Colors.green[600],
      //           child: Text(
      //             'دخول',
      //             style: TextStyle(color: Colors.white, fontSize: 24),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 12.0,
      //         ),
      //         Text(
      //           error,
      //           style: TextStyle(color: Colors.red, fontSize: 14.0),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
