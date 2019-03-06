import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';

class ZoomButtonAnimation extends StatelessWidget {
  final double begin;
  final double end;
  final AnimationController animationController;
  final Animation zoomAnimation;
  final Function onAnimationCompleted;

  ZoomButtonAnimation(
      {Key key,
      @required this.begin,
      @required this.end,
      @required this.animationController,
      this.onAnimationCompleted})
      : zoomAnimation = Tween(
          begin: begin,
          end: end,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn)),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return PlainButton(
      zoomButtonAnimation: zoomAnimation,
      initialWidth: begin,
      finalWidth: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    animationController.addListener(() {
      if (zoomAnimation.isCompleted) {
        onAnimationCompleted();
      }
    });

    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
    );
  }
}
