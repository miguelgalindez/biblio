import 'package:biblio/blocs/loginScreenBloc.dart';
import 'package:biblio/components/customTextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginForm extends StatelessWidget {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        StreamBuilder(
          stream: loginScreenBloc.formIsValid,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData)
              return Text("Is valid: ${snapshot.data}",
                  style: TextStyle(color: Colors.white));
            else
              return Text("Error", style: TextStyle(color: Colors.white));
          },
        ),
        StreamBuilder(
            stream: loginScreenBloc.usernameErrors,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return CustomTextInput(
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
              onChanged: loginScreenBloc.passwordSink.add,
              errorText: snapshot.data,
              onFieldSubmitted: (String value) {
                _usernameFocusNode.unfocus();
                // As the best option didn't work, i used the second one as stackoverflow's user suggest: https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard
                // FocusScope.of(context).requestFocus(FocusNode());
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
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
