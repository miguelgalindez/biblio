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
      this.initialWidth = 320,
      this.finalWidth = 70,
      this.initialBorderRadius = 10.0,
      this.finalBorderRadius = 30.0,
      this.height = 60,
      this.text = ""})
      : assert(initialWidth > finalWidth),
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
    if (zoomButtonAnimation != null && (zoomButtonAnimation.status==AnimationStatus.forward || zoomButtonAnimation.status==AnimationStatus.completed)) {
      double incrementRate=zoomButtonAnimation.value/height;
      double t=zoomButtonAnimation.value-finalWidth;
      double increment=incrementRate*t;
      return height+increment;
    }
    return height;
  }

  double _getBorderRadius() {
    if (zoomButtonAnimation != null &&
        zoomButtonAnimation.status == AnimationStatus.forward) {      
      return finalBorderRadius;
    } else {
      double incrementRate = (finalBorderRadius - initialBorderRadius) /
          (initialWidth - finalWidth);
      double t = initialWidth - _getWidth();
      double increment = incrementRate * t;
      return initialBorderRadius + increment;
    }
  }

  Decoration _getDecoration() {
    if (zoomButtonAnimation != null && zoomButtonAnimation.value > 300) {
      return BoxDecoration(
        shape: zoomButtonAnimation.value < 600
            ? BoxShape.circle
            : BoxShape.rectangle,
        color: Colors.red[700],
      );
    } else {
      return BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.all(Radius.circular(_getBorderRadius())));
    }
  }

  Widget _getChild() {
    Widget buttonText = Text(text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ));

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
          alignment: Alignment.center,
          margin: EdgeInsets.all(0.0),
          width: _getWidth(),
          height: _getHeight(),
          decoration: _getDecoration(),
          child: _getChild()),
      onTap: onTap,
    );
  }
}
