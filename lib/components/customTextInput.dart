import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function validator;
  final TextInputAction textInputAction;
  final Function onFieldSubmitted;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final String label;

  CustomTextInput(
      {Key key,
      this.keyboardType = TextInputType.text,
      @required this.obscureText,
      @required this.label,
      this.icon,
      this.controller,
      this.validator,
      this.textInputAction,
      this.onFieldSubmitted,
      this.focusNode})
      : assert(obscureText != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    var textStyle = themeData.textTheme.subhead.copyWith(color: Colors.white);
    var errorStyle = textStyle.copyWith(color: themeData.errorColor);

    return TextFormField(
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      maxLines: 1,
      obscureText: obscureText,
      style: textStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: textStyle,
        errorStyle: errorStyle,
        errorMaxLines: 2,
      ),
    );
  }
}