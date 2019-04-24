import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class Logo extends StatelessWidget {
  final AssetImage image;
  final double height;
  final double width;
  final Duration animationDuration;

  Logo(
      {Key key,
      @required this.image,
      this.height = 200.0,
      this.width = 200.0,
      this.animationDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animator(
      duration: animationDuration,
      curve: Curves.bounceInOut,
      tween: Tween(begin: 0.01, end: 1.0),
      builder: (Animation animation) => Transform.scale(
            scale: animation.value,
            child: Image(
              height: height,
              width: width,
              image: image,
            ),
          ),      
    );
  }
}
