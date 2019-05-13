import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/components/logo.dart';
import 'package:biblio/components/forms/loginForm.dart';
import 'package:biblio/components/buttons/animatedButton.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/screens/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';
import 'package:biblio/services/categories-mock-data.dart';

class LoginScreen extends StatefulWidget {
  static final AssetImage logoImage = const AssetImage("assets/appLogo.png");
  final AssetImage backgroundImage =
      const AssetImage("assets/login-background.jpg");

  final Logo logo = Logo(
    image: logoImage,
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

  Future<void> _signIn(BuildContext context) async {
    //await UserServices.signIn(username, password, AppConfig.of(context));
    AppVariables appVariables = ScopedModel.of<AppVariables>(context);
    appVariables.user = User(
        name: "Miguel Angel",
        username: "miguelgalindez",
        isAuthenticated: true,
        id: 123);

    appVariables.addCategories(await getCategories(context));
    appVariables.addBooks(getBooks());
  }

  Function _handleAnimationCompleted(BuildContext context) => () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      };

  Widget _buildFormLayout(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Orientation orientation = mediaQueryData.orientation;

    Widget formWidget = LoginForm(
      onFormChange: handleFormChange,
      formKey: widget._formKey,
    );

    Widget loginButton = AnimatedButton(
      text: "Iniciar sesión",
      formKey: widget._formKey,
      onTap: () async => _signIn(context),
      onAnimationCompleted: _handleAnimationCompleted(context),
      screenSize: mediaQueryData.size,
      horizontalPadding: widget.horizontalPadding,
    );

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
                formWidget,
                SizedBox(height: 80.0),
              ],
            ),
          ),
          loginButton,
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
                  child: Column(
                    children: <Widget>[
                      formWidget,
                      SizedBox(height: 40.0),
                      loginButton,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black.withOpacity(0.77);
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomPadding: true,
        backgroundColor: backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: widget.backgroundImage,
              fit: BoxFit.cover,
              color: backgroundColor,
              colorBlendMode: BlendMode.darken,
            ),
            Center(
              child: SingleChildScrollView(
                child: _buildFormLayout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
