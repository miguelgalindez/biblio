import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';

class ZoomButtonAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Animation zoomAnimation;
  final Function onAnimationCompleted;
  final MediaQueryData mediaQueryData;

  ZoomButtonAnimation(
      {Key key,
      @required this.animationController,
      this.onAnimationCompleted,
      @required this.mediaQueryData})
      : zoomAnimation = Tween(
          // TODO: dynamic begin and end. These must be a parameter
          begin: 70.0,
          end: mediaQueryData.orientation == Orientation.portrait
              ? mediaQueryData.size.height
              : mediaQueryData.size.width,
        ).animate(CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn)),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return PlainButton(
      zoomButtonAnimation: zoomAnimation,
      mediaQueryData: mediaQueryData,
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
