import 'package:barka/services/auth.dart';
import 'package:barka/shared/constants.dart';
import 'package:barka/shared/loading.dart';
import 'package:barka/shared/logo.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SignupWithPhone extends StatefulWidget {
  @override
  _SignupWithPhoneState createState() => _SignupWithPhoneState();
}

class _SignupWithPhoneState extends State<SignupWithPhone> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String phoneNumber = '';
  String error = '';

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = internationalizedPhoneNumber;
      print(internationalizedPhoneNumber);
    });
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
                          InternationalPhoneInput(
                              decoration:
                                  textInputDecorationSignInAndSignIn.copyWith(
                                      counterText: '',
                                      hintText: 'رقم الجوال',
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Amiri',
                                          height: 1.0)),
                              onPhoneNumberChange: onPhoneNumberChange,
                              initialPhoneNumber: phoneNumber,
                              initialSelection: '+966',
                              showCountryCodes: true),
                          // TextFormField(
                          //   decoration:
                          // textInputDecorationSignInAndSignIn.copyWith(
                          //     counterText: '',
                          //     hintText: 'رقم الجوال',
                          //     hintStyle: TextStyle(
                          //         fontSize: 16,
                          //         fontFamily: 'Amiri',
                          //         height: 1.0)),
                          //   validator: EmailValidator.validate,
                          //   onChanged: (val) {
                          //     setState(() {
                          //       phoneNumber = val;
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: height * 0.092,
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
                                if (phoneNumber != '') {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.createUserWithPhoneNumber(
                                          phoneNumber, context);
                                  if (result is String) {
                                    setState(() {
                                      error = result;
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
