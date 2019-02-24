import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final String label;
  final Function validator;

  TextInput(
      {Key key,
      this.keyboardType,
      @required this.obscureText,
      @required this.label,
      this.icon,
      this.validator})
      : assert(obscureText != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.white);

    return TextFormField(
        maxLines: 1,
        keyboardType:
            this.keyboardType != null ? this.keyboardType : TextInputType.text,
        obscureText: this.obscureText,
        style: textStyle,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          prefixIcon: Icon(this.icon, color: Colors.white),
          labelText: this.label,
          labelStyle: textStyle,
        ),
        validator: this.validator);
  }
}
