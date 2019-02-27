import 'package:flutter/material.dart';

class PlainButton extends StatelessWidget {
  final Animation shrinkButtonAnimation;
  final Animation zoomButtonAnimation;
  final Function onTap;
  final double initWidth;
  final double compresssedWidth;
  final double height;
  final String text;

  PlainButton(
      {Key key,
      this.shrinkButtonAnimation,
      this.zoomButtonAnimation,
      this.onTap,
      this.initWidth = 320,
      this.compresssedWidth = 70,
      this.height = 60,
      @required this.text});

  final Widget progressIndicator = CircularProgressIndicator(
      strokeWidth: 3.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white));

  double _getWidth() {
    if (shrinkButtonAnimation != null) {
      return shrinkButtonAnimation.value;
    } else if (zoomButtonAnimation != null) {
      return zoomButtonAnimation.value;
    }
    return initWidth;
  }

  double _getHeight() {
    if (zoomButtonAnimation != null) {
      return zoomButtonAnimation.value;
    }
    return height;
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
          borderRadius: BorderRadius.all(const Radius.circular(30.0)));
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
      if (zoomButtonAnimation.value < 300) {
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