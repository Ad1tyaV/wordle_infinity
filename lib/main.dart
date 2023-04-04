import 'package:flutter/material.dart';
import 'package:wordle_infinity/pages/main_page.dart';
import './assets/constants.dart' as constants;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.title,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MainPage(),
    );
  }
}