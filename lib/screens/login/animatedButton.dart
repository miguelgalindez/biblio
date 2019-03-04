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
  final GlobalKey<FormState> formKey;
  AnimatedButton(
      {Key key, @required this.username, @required this.password, this.formKey})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController shrinkButtonAnimationController;
  bool showShrinkButtonAnimation;
  Future<User> loginPromise;
  AppConfig appConfig;

  @override
  void initState() {
    super.initState();
    showShrinkButtonAnimation = false;
    shrinkButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
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
      showShrinkButtonAnimation = false;
    });
  }

  AppConfig _getAppConfig(BuildContext context) {
    if (appConfig == null) {
      var config = AppConfig.of(context);
      setState(() {
        appConfig = config;
      });
      return config;
    }
    return appConfig;
  }

  Future<void> _signIn(BuildContext context) async {
    if (widget.formKey == null || widget.formKey.currentState.validate()) {
      setState(() {
        showShrinkButtonAnimation = true;
      });
      _playShrinkAnimation();
      try {
        User user = await UserServices.signIn(
            widget.username, widget.password, _getAppConfig(context));
        print("ok " + user.username + " " + user.isAuthenticated.toString());
      } catch (e) {
        await _rewindShrinkAnimation();
        _showSnackbar(e.toString(), null, context);
      }
    }
  }

  Future<void> _showSnackbar(
      String msg, SnackBarAction action, BuildContext context) async {
    var textStyle = Theme.of(context).textTheme.subhead.copyWith(
          color: Colors.white,
        );

    var snackbar = SnackBar(
      content: Text(msg, style: textStyle),
      action: action,
      duration: Duration(seconds: 8),
    );
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return !showShrinkButtonAnimation
        ? PlainButton(
            text: "Sign in",
            onTap: () async => _signIn(context),
          )
        : ShrinkButtonAnimation(
            animationController: shrinkButtonAnimationController,
          );
  }
}
