import 'package:flutter/material.dart';

class ShowAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;
  final double width;
  final double height;
  final Color backgroundColor;

  ShowAnimation(
      {@required this.child,
      @required this.animationController,
      this.width,
      this.height,
      this.backgroundColor});

  double _getScale(double finalSize, double percentage) {
    if (finalSize != null && finalSize > 0) {
      return percentage * finalSize;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, Widget child) {
        return animationController.isCompleted
            ? child
            : Container(
                width: _getScale(width, animationController.value),
                height: _getScale(height, animationController.value),
                decoration: BoxDecoration(color: backgroundColor),
              );
      },
    );
  }
}
