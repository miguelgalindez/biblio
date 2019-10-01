import 'dart:async';
import 'package:biblio/blocs/loginScreenBloc.dart';
import 'package:biblio/components/forms/loginForm.dart';
import 'package:biblio/ui/screens/login/_loginForm.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // Global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final GlobalKey _formKey;
  final Image backgroundImage;
  final Image logo;
  final double horizontalPadding;
  final Widget form;

  LoginScreen({Key key})
      : horizontalPadding = 24.0,
        _formKey = GlobalKey<FormState>(),        
        backgroundImage = Image(
          image: const AssetImage("assets/img/login-background.jpg"),
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.77),
          colorBlendMode: BlendMode.darken,
        ),
        logo = Image(
          image: const AssetImage("assets/img/appLogo.png"),
          height: 200,
          width: 200,
        ),
        form = LoginForm(),
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    loginScreenBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    loginScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.77),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[widget.backgroundImage, _buildFormLayout(context)],
        ),
      ),
    );
  }

  Widget _buildFormLayout(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Orientation orientation = mediaQueryData.orientation;

    if (orientation == Orientation.portrait) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.logo,
                SizedBox(height: 40.0),
                widget.form,
                SizedBox(height: 80.0),
              ],
            ),
          ),
          //loginButton,
        ],
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.logo,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Column(
                      children: <Widget>[
                        widget.form,
                        SizedBox(height: 20.0),
                        //loginButton,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
