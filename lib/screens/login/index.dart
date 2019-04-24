import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/components/logo.dart';
import 'package:biblio/screens/login/loginForm.dart';
import 'package:biblio/screens/login/animatedButton.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/screens/home/index.dart';

class LoginScreen extends StatefulWidget {
  final Logo logo = Logo(
    image: const AssetImage("assets/appLogo.png"),
    animationDuration: const Duration(seconds: 1),
  );  

  final double horizontalPadding = 24.0;
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final GlobalKey _formKey = GlobalKey<FormState>();

  LoginScreen({Key key}) : super(key: key);

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

  Function _handleAnimationCompleted(BuildContext context) => () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      };

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Color backgroundColor = Colors.black.withOpacity(0.77);
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomPadding: true,
        backgroundColor: backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image(
              image: AssetImage("assets/login-background.jpg"),
              fit: BoxFit.cover,
              color: backgroundColor,
              colorBlendMode: BlendMode.darken,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.logo,
                  SizedBox(height: 40.0),
                  LoginForm(
                    onFormChange: handleFormChange,
                    formKey: widget._formKey,
                  ),
                  SizedBox(height: 80.0),
                  AnimatedButton(
                    text: "Iniciar sesión",
                    username: username,
                    password: password,
                    formKey: widget._formKey,
                    onAnimationCompleted: _handleAnimationCompleted(context),
                    screenSize: mediaQueryData.size,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * Column(
              children: <Widget>[
                widget.logo,
                SizedBox(height: 20.0),
                LoginForm(
                  horizontalPadding: widget.horizontalPadding,
                  onFormChange: handleFormChange,
                  formKey: widget._formKey,
                ),
                SizedBox(height: 80.0),
                AnimatedButton(
                  text: "Iniciar sesión",
                  horizontalPadding: widget.horizontalPadding,
                  username: username,
                  password: password,
                  formKey: widget._formKey,
                  onAnimationCompleted: _handleAnimationCompleted(context),
                  screenSize: mediaQueryData.size,
                ),
              ],
            ),
 */
