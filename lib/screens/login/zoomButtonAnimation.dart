import 'package:flutter/material.dart';
import 'package:biblio/screens/login/plainButton.dart';

class ZoomButtonAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Animation zoomAnimation;
  final Function onAnimationCompleted;

  ZoomButtonAnimation({Key key, @required this.animationController, this.onAnimationCompleted})
      : zoomAnimation = Tween(
          // TODO: dynamic begin and end. These must be a parameter
          begin: 70.0,
          end: 900.0,
        ).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(0.550, 0.999, curve: Curves.bounceOut))),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return PlainButton(zoomButtonAnimation: zoomAnimation);
  }

  @override
  Widget build(BuildContext context) {    
    animationController.addListener((){
      if(zoomAnimation.isCompleted){
          onAnimationCompleted();
      }
    }); 

    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
    );
  }
}
