import 'package:flutter/material.dart';
import 'package:biblio/components/logo.dart';
import 'package:biblio/screens/login/loginForm.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  final Widget logo = Logo(image: AssetImage("assets/appLogo.png"));

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool buttonClicked = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
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
                    LoginForm(),
                    SizedBox(height: 80.0),
                  ],
                ),
                !buttonClicked
                    ? InkWell(
                        child: SignIn(),
                        onTap: () {
                          setState(() {
                            buttonClicked=true;
                          });
                        },
                      )
                    : Text(buttonClicked.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(0.0),
      width: 320.0,
      height: 60.0,
      decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.all(const Radius.circular(30.0))),
      child: Text(
        "Sign in",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
