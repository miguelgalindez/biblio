import 'package:flutter/material.dart';
import 'package:biblio/components/Logo.dart';
import 'package:biblio/components/LoginForm.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  static final DecorationImage appLogo = DecorationImage(
    image: AssetImage('assets/appLogo.png'),
    fit: BoxFit.cover,
  );

  final Widget appLogoWidget = Logo(image: appLogo);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Color(0xff01305c),
      body: Center(
        child: SingleChildScrollView(
          child: media.orientation == Orientation.portrait
              ? Column(                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.appLogoWidget,
                    LoginForm(),
                  ],
                )
              : Row(                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: widget.appLogoWidget),
                    Expanded(child: LoginForm())
                  ],
                ),
        ),
      ),
    );
  }
}
