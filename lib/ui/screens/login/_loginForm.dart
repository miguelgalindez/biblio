import 'dart:async';

import 'package:biblio/blocs/loginScreenBloc.dart';
import 'package:biblio/components/customTextInput.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  FocusNode _usernameFocusNode;
  FocusNode _passwordFocusNode;
  StreamSubscription<BlocEvent> _eventsSubscription;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController.text = loginScreenBloc.username.value;
    _passwordController.text = loginScreenBloc.password.value;
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _eventsSubscription = loginScreenBloc.events.listen(_eventsHandler);
    super.initState();
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _eventsHandler(BlocEvent event) async {
    if (event.action == LoginScreenAction.SIGN_IN) {
      _usernameFocusNode.unfocus();
      _passwordFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        StreamBuilder(
            stream: loginScreenBloc.usernameErrors,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CustomTextInput(
                controller: _usernameController,
                onChanged: loginScreenBloc.usernameSink.add,
                errorText: snapshot.data,
                onFieldSubmitted: (String value) {
                  _usernameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                focusNode: _usernameFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                label: "Usuario institucional",
                icon: Icons.person,
              );
            }),
        SizedBox(height: 10.0),
        StreamBuilder(
          stream: loginScreenBloc.passwordErrors,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return CustomTextInput(
              controller: _passwordController,
              onChanged: loginScreenBloc.passwordSink.add,
              errorText: snapshot.data,
              onFieldSubmitted: (String value) => _usernameFocusNode.unfocus(),
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
              obscureText: true,
              label: "Contraseña",
              icon: Icons.lock,
            );
          },
        ),
      ],
    );
  }
}
