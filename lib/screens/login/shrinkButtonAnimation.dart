import 'package:flutter/material.dart';
import 'package:biblio/components/plainButton.dart';

class ShrinkButtonAnimation extends StatelessWidget {
  final double begin;
  final double end;
  final AnimationController animationController;
  final Animation shrinkAnimation;

  ShrinkButtonAnimation(
      {Key key,
      @required this.begin,
      @required this.end,
      @required this.animationController})
      : shrinkAnimation = Tween(
          begin: begin,
          end: end,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Interval(0.0, 0.150))),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return PlainButton(
      shrinkButtonAnimation: shrinkAnimation,
      initialWidth: begin,
      finalWidth: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
    );
  }
}
