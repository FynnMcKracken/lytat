
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lytatapp/LoadingScreen.dart';

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  final colorSwatch = Colors.lightBlue;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Lytat',
            home: LoadingScreen(title: 'Error'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Lytat',
            theme: ThemeData(
              primarySwatch: colorSwatch,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark(),
            home: Home(title: 'Lytat'),
          );
        }

        return MaterialApp(
          title: 'Lytat',
          home: LoadingScreen(),
        );
      },
    );

  }
}
