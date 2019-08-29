import 'package:flutter/material.dart';

class ChangeSizeAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;
  final Size initialSize;
  final Size finalSize;
  ChangeSizeAnimation(
      {@required this.animationController,
      @required this.child,
      @required this.initialSize,
      @required this.finalSize});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, Widget child) {
        Size size =
            _getCurrentSize(initialSize, finalSize, animationController.value);
        return Container(
          height: size.height,
          width: size.width,
          child: child,
        );
      },
    );
  }

  Size _getCurrentSize(Size initialSize, Size finalSize, double scale) {
    return Size(_getIncrement(initialSize.width, finalSize.width, scale),
        _getIncrement(initialSize.height, finalSize.height, scale));
  }

  double _getIncrement(double initialValue, double finalValue, double scale) {
    return initialValue + (scale * (finalValue - initialValue));
  }
}
