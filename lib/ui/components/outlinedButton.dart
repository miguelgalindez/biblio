import 'package:flutter/material.dart';

class OutlinedButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;
  final Function onPressed;
  OutlinedButton(
      {@required this.text,
      @required this.textStyle,
      @required this.color,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(text, style: textStyle),
      borderSide: BorderSide(color: color, width: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color,
      onPressed: onPressed,
    );
  }
}