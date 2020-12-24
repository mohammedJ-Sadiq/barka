import 'package:firebase_auth/firebase_auth.dart';
import 'package:barka/models/user.dart';
import 'package:barka/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).createUserData(name);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
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
      return "Email cannot be empty ";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "password cannot be empty";
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "name cannot be empty ";
    }
    if (value.length < 2) {
      return 'name must be at least 2 characters long';
    }
    if (value.length > 50) {
      return 'name must be less than 50 characters long';
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
