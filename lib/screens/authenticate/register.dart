import 'package:barka/shared/constants.dart';
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff28d1ab),
                  Color(0xbb5dfe60),
                  Color(0xff28d1ab)
                ]),
          ),
          child: Column(
            children: [
              Container(
                height: 250,
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  "بركة",
                  style: TextStyle(
                      fontSize: 52, fontFamily: 'Aref', color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     begin: Alignment.bottomLeft,
                    //     end: Alignment.topRight,
                    //     colors: [Color(0x5dfe60), Color(0xff28d1ab)]),
                    border: Border.all(color: Colors.transparent),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'البريد الإلكتروني',
                            hintStyle:
                                TextStyle(fontSize: 16, fontFamily: 'Amiri')),
                        validator: EmailValidator.validate,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'كلمة المرور',
                          hintStyle:
                              TextStyle(fontSize: 16, fontFamily: 'Amiri'),
                        ),
                        validator: PasswordValidator.validate,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'الأسم الكامل',
                            hintStyle:
                                TextStyle(fontSize: 16, fontFamily: 'Amiri')),
                        validator: NameValidator.validate,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xbb5dfe60),
                                    Color(0xff28d1ab)
                                  ]),
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
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لديك حساب مسبق ؟ ',
                    style: TextStyle(fontSize: 16),
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
          width: double.infinity,
          height: 900,
        ),
      ),
    );
  }
}
