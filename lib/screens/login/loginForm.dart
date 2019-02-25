import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:biblio/components/textInput.dart';
import 'package:biblio/validators/userValidator.dart';

/**
 * TODO: use shared preferences to store the state before
 * the widget is disposed (Screen rotation, app killing or app leaving)
 * 
 * TODO: Check what other lifecycle events should be tracked
 */

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    _usernameController.addListener(_updateUsername);
    _passwordController.addListener(_updatePassword);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){    
    print("State: "+state.toString());
  }

  @override void didChangeMetrics() {
    print("Screen was rotated. Width ${window.physicalSize.width}. Height: ${window.physicalSize.height}");    
  }

  


  _updateUsername() {
    setState(() {
      username = _usernameController.text;
    });
  }

  _updatePassword() {
    setState(() {
      password = _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextInput(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  label: "Usuario institucional",
                  icon: Icons.person,
                  controller: _usernameController,
                  validator: validateUsername,
                ),
                SizedBox(height: 20.0),
                TextInput(
                  obscureText: true,
                  label: "Contraseña",
                  icon: Icons.lock,
                  controller: _passwordController,
                  validator: validatePassword,
                ),
                SizedBox(height: 20.0),

                /*
                Container(                  
                  width: 320.0,
                  height: 60.0,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(166, 22, 24, 1.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(15.0))),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3),
                  ),
                )
                */
                RaisedButton(
                  child: Text("Sign in"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Processing data..."),
                      ));
                    }
                  },
                ),
                Text(username),
                Text(password),
              ],
            ),
          )
        ],
      ),
    );
  }
}
