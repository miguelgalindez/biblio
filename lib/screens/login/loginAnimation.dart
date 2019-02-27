import 'package:flutter/material.dart';

class LoginAnimation extends StatefulWidget {
  final AnimationController buttonAnimationController;
  final Animation shrinkButtonAnimaton;
  final Animation zoomButtonAnimation;
  final String username;
  final String password;

  LoginAnimation({Key key, @required this.buttonAnimationController, this.username, this.password})
      : shrinkButtonAnimaton = Tween(
          begin: 320.0,
          end: 70.0,
          // For better animation i used CurvedAnimation
        ).animate(
          CurvedAnimation(
              parent: buttonAnimationController, curve: Interval(0.0, 0.150)),
        ),
        zoomButtonAnimation = Tween(
          begin: 70.0,
          // TODO: Check the largest side of the screen
          end: 900.0,
        ).animate(
          CurvedAnimation(
              parent: buttonAnimationController,
              curve: Interval(0.550, 0.999, curve: Curves.bounceInOut)),
        ),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return zoomButtonAnimation.value < 300
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(0.0),
            width: shrinkButtonAnimaton.value,
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.all(const Radius.circular(30.0))),
            child: shrinkButtonAnimaton.value > 75
                ? Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                    ),
                  )
                : CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
          )
        : Container(
            width: zoomButtonAnimation.value,
            height: zoomButtonAnimation.value,
            decoration: BoxDecoration(
              shape: zoomButtonAnimation.value < 600
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              color: Colors.red[700],
            ),
          );
  }

  @override
  _LoginAnimationState createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: widget._buildAnimation,
      animation: widget.buttonAnimationController,
    );
  }
}
