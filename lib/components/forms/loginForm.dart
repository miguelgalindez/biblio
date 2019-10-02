import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:biblio/components/customTextInput.dart';
import 'package:biblio/validators/userValidator.dart';

/**
 * TODO: use shared preferences to store the state before
 * the widget is disposed (Screen rotation, app killing or app leaving)
 * 
 * TODO: Check what other lifecycle events should be tracked
 * 
 * TODO: handle http exceptions 
 * TOTO: remove username and password and put them into index.
 */

class LoginFormLegacy extends StatefulWidget {
  final double horizontalPadding;
  final Function onFormChange;
  final GlobalKey<FormState> formKey;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  LoginFormLegacy(
      {Key key,
      @required this.onFormChange,
      this.formKey,
      this.horizontalPadding = 0.0})
      : super(key: key);

  @override
  _LoginFormLegacyState createState() => _LoginFormLegacyState();
}

class _LoginFormLegacyState extends State<LoginFormLegacy> with WidgetsBindingObserver {
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = new TextEditingController(text: "");
    _passwordController = new TextEditingController(text: "");
    _usernameController.addListener(handleFieldChange);
    _passwordController.addListener(handleFieldChange);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _usernameController.dispose();
    _passwordController.dispose();
    print("Disponsing widget !!!");
    super.dispose();
  }

  void handleFieldChange() {
    widget.onFormChange(_usernameController.text, _passwordController.text);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State: " + state.toString());
  }

  /*
    The event handled here is fired when the screen changes its size,
    for example, when it is rotated or in other situations such as 
    keyboard display
  @override void didChangeMetrics() {
    
  }
  */

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CustomTextInput(
            controller: _usernameController,
            validator: UserValidator.validateUsername,
            focusNode: widget._usernameFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String value) {
              widget._usernameFocusNode.unfocus();
              FocusScope.of(context).requestFocus(widget._passwordFocusNode);
            },
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            label: "Usuario institucional",
            icon: Icons.person,
          ),
          SizedBox(height: 10.0),
          CustomTextInput(
            controller: _passwordController,
            validator: UserValidator.validatePassword,
            focusNode: widget._passwordFocusNode,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (String value) {
              widget._usernameFocusNode.unfocus();
              // As the best option didn't work, i used the second one as stackoverflow's user suggest: https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard
              // FocusScope.of(context).requestFocus(FocusNode());
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            obscureText: true,
            label: "Contraseña",
            icon: Icons.lock,
          ),
        ],
      ),
    );
  }
}
