import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';
import 'package:biblio/screens/login/shrinkButtonAnimation.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/services/userServices.dart';
import 'package:biblio/models/appConfig.dart';

class AnimatedButton extends StatefulWidget {
  final String username;
  final String password;
  final AppConfig appConfig;
  AnimatedButton(
      {Key key,
      @required this.username,
      @required this.password,
      @required this.appConfig});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController shrinkButtonAnimationController;
  bool buttonClicked;
  Future<User> loginPromise;

  @override
  void initState() {
    super.initState();
    buttonClicked = false;
    shrinkButtonAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    shrinkButtonAnimationController.dispose();
    super.dispose();
  }  

  Future<void> _playShrinkAnimation() async {
    await shrinkButtonAnimationController.forward();
  }

  Future<void> _rewindShrinkAnimation() async {
    await shrinkButtonAnimationController.reverse();
    setState(() {
      buttonClicked = false;
    });
  }

  signIn() async {
    print("Trying to sign in");
    try {
      User user = await UserServices.signIn(
          widget.username, widget.password, widget.appConfig);
      print("ok " + user.username + " " + user.isAuthenticated.toString());
    } catch (e) {
      _rewindShrinkAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !buttonClicked
        ? PlainButton(
            text: "Sign in",
            onTap: () async {
              setState(() {
                buttonClicked = true;
              });
              _playShrinkAnimation();
              signIn();
            },
          )
        : ShrinkButtonAnimation(
            animationController: shrinkButtonAnimationController,
          );
  }
}
