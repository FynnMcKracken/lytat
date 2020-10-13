
import 'package:flutter/material.dart';
import 'package:lytatapp/home.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  final colorSwatch = Colors.lightBlue;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: colorSwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      home: Home(title: 'Lytat'),
    );
  }
}
