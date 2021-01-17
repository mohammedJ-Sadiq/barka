import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  CustomUser _userFromFirebaseUser(User user) {
    return user != null && user.emailVerified
        ? CustomUser(uid: user.uid)
        : null;
  }

  // auth change user stream

  Stream<CustomUser> get user {
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
      await DatabaseService(uid: user.uid).createUserData(name);
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  // verify email
  // Timer timer;
  // Future verifyEmail(User user) async {
  //   user.sendEmailVerification();
  //   timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     if (user.emailVerified) {
  //       timer.cancel();
  //       user.reload();
  //       return _userFromFirebaseUser(user);
  //     }
  //   });
  // }

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
  Future createUserWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {})
              .catchError((e) {
            return 'error';
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          return 'error';
        },
        codeSent: (String verficationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text('أدخل رمز التحقق'),
                    content: Column(
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
                        onPressed: () {
                          var _credential = PhoneAuthProvider.getCredential(
                              verificationId: verficationId,
                              smsCode: _codeController.text.trim());
                          _auth
                              .signInWithCredential(_credential)
                              .then((UserCredential result) {})
                              .catchError((e) {
                            return 'error';
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificaionId) {
          verificaionId = verificaionId;
          print(verificaionId);
          print('Timeout');
        });
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
