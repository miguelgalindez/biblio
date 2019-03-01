import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/components/logo.dart';
import 'package:biblio/screens/login/loginForm.dart';
import 'package:biblio/screens/login/animatedButton.dart';
import 'package:biblio/services/userServices.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/models/appConfig.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  final Widget logo = Logo(image: AssetImage("assets/appLogo.png"));

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String username;
  String password;
  Future<User> user;

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleFormChange(String username, String password) {
    setState(() {
      this.username = username;
      this.password = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Color(0xff01305c),
        body: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    widget.logo,
                    SizedBox(height: 20.0),                    
                    LoginForm(onFormChange: handleFormChange),
                    SizedBox(height: 80.0),
                  ],
                ),
                AnimatedButton(
                  username: username,
                  password: password,
                  appConfig: appConfig,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
