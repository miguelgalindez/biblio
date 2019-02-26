import 'package:flutter/material.dart';
import 'package:biblio/screens/login/loginAnimation.dart';

class SignInButton extends StatefulWidget {
  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton>
    with TickerProviderStateMixin {
  var animationStatus;
  AnimationController _loginButtonController;

  var signInButton = Container(
    width: 320.0,
    height: 60.0,
    alignment: FractionalOffset.center,
    decoration: BoxDecoration(
        color: const Color.fromRGBO(166, 22, 24, 1.0),
        borderRadius: BorderRadius.all(const Radius.circular(15.0))),
    child: Text(
      "Sign in",
      style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3),
    ),
  );

  @override
  void initState() {
    super.initState();
    animationStatus = 0;
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      //await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return animationStatus == 0
        ? Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: InkWell(
              onTap: () async {
                setState(() {
                  animationStatus = 1;
                });
                //_playAnimation();
              },
              child: signInButton,
            ),
          )
        : StaggerAnimation(
            buttonController: _loginButtonController.view,
          );
  }
}
