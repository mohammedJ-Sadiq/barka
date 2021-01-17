import 'package:barka/models/custom_user.dart';
import 'package:barka/models/custom_user.dart';
import 'package:barka/screens/wrapper.dart';
import 'package:barka/services/auth.dart';
import 'package:barka/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return StreamProvider<CustomUser>.value(
                value: AuthService().user,
                child: MaterialApp(
                  localizationsDelegates: [
                    // ... app-specific localization delegate[s] here
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('en', ''), // English, no country code
                    const Locale('ar', 'AE'), // Arabic, no country code
                    // ... other locales the app supports
                  ],
                  locale: Locale('ar', 'AE'),
                  home: Wrapper(),
                ));
          } else {
            return Loading();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
