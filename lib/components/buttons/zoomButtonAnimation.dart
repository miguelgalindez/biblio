import 'package:flutter/material.dart';
import 'package:biblio/components/buttons/plainButton.dart';

class ZoomButtonAnimation extends StatelessWidget {
  final double begin;
  final Size screenSize;
  final AnimationController animationController;
  final Animation zoomAnimation;

  ZoomButtonAnimation(
      {Key key,
      @required this.begin,
      @required this.screenSize,
      @required this.animationController})
      : zoomAnimation = Tween(
          begin: begin,
          end: screenSize.width,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return PlainButton(
          zoomButtonAnimation: zoomAnimation,
          initialWidth: begin,
          finalWidth: screenSize.width,
          screenSize: screenSize,
        );
      },
    );
  }
}
