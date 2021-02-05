import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barka/screens/authenticate/create_username_for_phoneuser.dart';
import 'package:flushbar/flushbar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(User user) {
    if (user != null) {
      if (user.email != null) {
        return user.emailVerified ? user : null;
      } else if (user.phoneNumber != null) {
        return user;
      }
    }
    return null;
  }

  // auth change user stream

  Stream<User> get user {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (!user.emailVerified) {
        print(user);
        return 'errorMsg4';
      } else {
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());

      return e.message;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      // create a new document for the user with the uid
      user.sendEmailVerification();
      await DatabaseService(uid: user.uid).createUserData(name, '');
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  // reset password
  Future sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  // Sign up with phone number
  final _codeController = TextEditingController();
  Future createUserWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            if (result.additionalUserInfo.isNewUser) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateUsernameForPhoneuser(
                            uid: result.user.uid,
                            phoneNumber: phoneNumber,
                          )));
            }
          }).catchError((e) {
            return e.toString();
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          return exception.toString();
        },
        codeSent: (String verficationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text('أدخل رمز التحقق'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _codeController,
                        )
                      ],
                    ),
                    actions: [
                      FlatButton(
                        child: Text('إرسال'),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () async {
                          var _credential = PhoneAuthProvider.credential(
                              verificationId: verficationId,
                              smsCode: _codeController.text.trim());

                          await _auth
                              .signInWithCredential(_credential)
                              .then((UserCredential result) {
                            print(result.additionalUserInfo.isNewUser);
                            if (result.additionalUserInfo.isNewUser) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateUsernameForPhoneuser(
                                            uid: result.user.uid,
                                            phoneNumber: phoneNumber,
                                          )));
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              return _userFromFirebaseUser(result.user);
                            }
                          }).catchError((e) {
                            showDialog(
                                context: context,
                                builder: (_) => new CupertinoAlertDialog(
                                      title: new Text('رمز التحقق خاطئ'),
                                      content: new Text("ادخل الرمز مرة أخرى؟"),
                                      actions: [
                                        FlatButton(
                                          child: Text(
                                            'نعم',
                                            style: TextStyle(
                                                color: Colors.red[800]),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('خروج'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificaionId) {
          verificaionId = verificaionId;
          print(verificaionId);
          Flushbar(
            message: 'انتهى الوقت المحدد لإدخال رمز التحقق',
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
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
  }

  void dispose() {
    _codeController.dispose();
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

// validation classes

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "يجب كتابة البريد الألكتروني";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "يجب كتابة كلمة المرور";
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "يجب كتابة الأسم";
    }
    if (value.length < 2) {
      return 'الأسم لابد أن يكون أكثر من حرفين';
    }
    if (value.length > 50) {
      return 'الأسم يجب أن يكون أقل من 50 حرف/رقم';
    }
    return null;
  }
}

class SessionNameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "الرجاء ادخال اسم الختمة";
    }
    return null;
  }
}

class PhoneNumberValidator {
  static String validate(String value) {
    if (value.length != 9) {
      return "رقم الجوال يجب أن يكون من 9 أرقام";
    }
    return null;
  }
}
