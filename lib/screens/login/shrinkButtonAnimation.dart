import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';

class ShrinkButtonAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Animation shrinkAnimation;

  ShrinkButtonAnimation({Key key, @required this.animationController})
      : shrinkAnimation = Tween(
          // TODO: dynamic begin and end
          begin: 320.0,
          end: 70.0,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Interval(0.0, 0.150))),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return PlainButton(shrinkButtonAnimation: shrinkAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
    );
  }
}
