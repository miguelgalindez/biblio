import 'package:flutter/material.dart';

class ClickableChip extends StatelessWidget {
  final Color backgroundColor;
  final Color initialTextColor;
  final Color clickedBackgroundColor;
  final Color clickedTextColor;
  final bool clicked;
  final Widget child;
  final Function onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  ClickableChip(
      {this.backgroundColor = Colors.white,
      this.initialTextColor = Colors.black,
      this.clickedBackgroundColor,
      this.clickedTextColor = Colors.white,
      this.clicked = false,
      @required this.child,
      @required this.onTap,
      this.margin,
      this.padding});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(30.0);
    Color textColor = clicked ? clickedTextColor : initialTextColor;
    TextStyle textStyle = Theme.of(context).textTheme.subhead.copyWith(
          color: textColor,
          fontWeight: FontWeight.normal,
        );

    return Card(
      margin: EdgeInsets.only(left: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      color: clicked ? clickedBackgroundColor : backgroundColor,
      child: InkWell(
        splashColor: clicked ? backgroundColor : clickedBackgroundColor,
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: IconTheme(
            data: IconThemeData(color: textColor),
            child: DefaultTextStyle(
              style: textStyle,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
