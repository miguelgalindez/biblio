import 'package:flutter/material.dart';
import 'package:biblio/screens/Login.dart';

void main() => runApp(MyApp());

ThemeData buildTheme(){
  final ThemeData base=ThemeData();  
  return base.copyWith(
    hintColor: Colors.white70
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblios',
      theme: buildTheme(),
      home: LoginScreen(),
    );
  }
}