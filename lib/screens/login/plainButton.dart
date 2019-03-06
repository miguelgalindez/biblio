import 'package:flutter/material.dart';

class PlainButton extends StatelessWidget {
  final Animation shrinkButtonAnimation;
  final Animation zoomButtonAnimation;
  final Function onTap;
  final double initialWidth;
  final double finalWidth;
  final double initialBorderRadius;
  final double finalBorderRadius;
  final double height;
  final String text;

  PlainButton(
      {Key key,
      this.shrinkButtonAnimation,
      this.zoomButtonAnimation,
      this.onTap,
      @required this.initialWidth,
      this.finalWidth = 0,
      this.initialBorderRadius = 10.0,
      this.finalBorderRadius = 30.0,
      this.height = 60,
      this.text = ""})
      : assert((shrinkButtonAnimation != null &&
                zoomButtonAnimation == null &&
                finalWidth > 0 &&
                initialWidth > finalWidth) ||
            (shrinkButtonAnimation == null &&
                zoomButtonAnimation != null &&
                finalWidth > 0 &&
                finalWidth > initialWidth) ||
            (shrinkButtonAnimation == null && zoomButtonAnimation == null)),
        assert(initialBorderRadius < finalBorderRadius),
        super(key: key);

  final Widget progressIndicator = CircularProgressIndicator(
      strokeWidth: 3.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white));

  double _getWidth() {
    if (shrinkButtonAnimation != null) {
      return shrinkButtonAnimation.value;
    } else if (zoomButtonAnimation != null) {
      return zoomButtonAnimation.value;
    }
    return initialWidth;
  }

  double _getHeight() {
    if (zoomButtonAnimation != null &&
        (zoomButtonAnimation.status == AnimationStatus.forward ||
            zoomButtonAnimation.status == AnimationStatus.completed)) {
      double incrementRate = zoomButtonAnimation.value / height;
      double t = zoomButtonAnimation.value - initialWidth;
      double increment = incrementRate * t;
      return height + increment;
    }
    return height;
  }

  double _getBorderRadius() {
    if (zoomButtonAnimation != null &&
        (zoomButtonAnimation.status == AnimationStatus.forward ||
            zoomButtonAnimation.status == AnimationStatus.completed)) {
      double decrementRate = finalBorderRadius / (finalWidth - initialWidth);
      double t = _getWidth() - initialWidth;
      double decrement = decrementRate * t;
      return finalBorderRadius - decrement;
    } else {
      double incrementRate = (finalBorderRadius - initialBorderRadius) /
          (initialWidth - finalWidth);
      double t = initialWidth - _getWidth();
      double increment = incrementRate * t;
      return initialBorderRadius + increment;
    }
  }

  Decoration _getDecoration() {
    return BoxDecoration(
        color: Colors.red[700],
        borderRadius: BorderRadius.all(Radius.circular(_getBorderRadius())));
  }

  Widget _getChild() {
    // TODO: Change this to use TextTheme
    Widget buttonText = Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.3,
      ),
    );

    if (shrinkButtonAnimation == null && zoomButtonAnimation == null) {
      return buttonText;
    }
    if (shrinkButtonAnimation != null) {
      return shrinkButtonAnimation.value > 75 ? buttonText : progressIndicator;
    } else if (zoomButtonAnimation != null) {
      if (zoomButtonAnimation.value < 100) {
        return progressIndicator;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      child: Container(
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.all(0.0),
          alignment: Alignment.center,
          width: _getWidth(),
          height: _getHeight(),
          decoration: _getDecoration(),
          child: _getChild()),
      onTap: onTap,
    );
  }
}
