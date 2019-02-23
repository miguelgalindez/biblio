import 'package:flutter/material.dart';
import 'package:biblio/screens/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblios',
      theme: ThemeData(
        primaryColor: Colors.white,              
      ),
      home: LoginScreen(),
    );
  }
}