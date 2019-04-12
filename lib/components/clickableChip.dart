import 'package:flutter/material.dart';

class ClickableChip extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color clickedBackgroundColor;
  final Color clickedTextColor;
  final bool clicked;
  final String text;
  final Function onTap;

  ClickableChip(
      {this.backgroundColor = Colors.white,
      this.textColor = Colors.black,
      this.clickedBackgroundColor,
      this.clickedTextColor = Colors.white,
      this.clicked = false,
      @required this.text,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: clicked ? clickedBackgroundColor : backgroundColor,
      splashColor: clicked ? backgroundColor : clickedBackgroundColor,
      padding: EdgeInsets.all(0.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subhead.copyWith(
              color: clicked ? clickedTextColor : textColor,
              fontWeight: FontWeight.normal,
            ),
      ),
      onPressed: onTap,
    );
  }
}
