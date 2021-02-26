import 'package:barka/screens/authenticate/create_username_for_phoneuser.dart';
import 'package:barka/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Wrapper());
      case '/createUsernameForPhoneuser':
        final CreateUsernameForPhoneuser args = settings.arguments;
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => CreateUsernameForPhoneuser(
                    uid: args.uid,
                    phoneNumber: args.phoneNumber,
                  ));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
