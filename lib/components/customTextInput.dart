import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function validator;
  final TextInputAction textInputAction;
  final Function onChanged;
  final Function onFieldSubmitted;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final String label;
  final String errorText;

  CustomTextInput(
      {Key key,
      this.keyboardType = TextInputType.text,
      @required this.obscureText,
      @required this.label,
      this.errorText,
      this.icon,
      this.controller,
      this.validator,
      this.textInputAction,
      this.onChanged,
      this.onFieldSubmitted,
      this.focusNode})
      : assert(obscureText != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final TextStyle textStyle = themeData.textTheme.subhead.copyWith(color: Colors.white);
    final TextStyle errorStyle = textStyle.copyWith(color: themeData.errorColor);
    const OutlineInputBorder border = const OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide: const BorderSide(color: Colors.white60),
    );

    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: themeData.errorColor),
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      maxLines: 1,
      obscureText: obscureText,
      style: textStyle,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: label,
        labelStyle: textStyle,
        errorStyle: errorStyle,
        errorMaxLines: 2,
        errorText: errorText,
      ),
    );
  }
}
