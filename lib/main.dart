import 'package:flutter/material.dart';
import 'package:biblio/components/Logo.dart';
import 'package:biblio/components/LoginForm.dart';

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

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  
  final DecorationImage appIcon = DecorationImage(
    image: AssetImage('assets/appIcon.png'),
    fit: BoxFit.cover,
  );

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff01305c),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Logo(image: widget.appIcon),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
