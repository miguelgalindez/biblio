import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:biblio/components/textInput.dart';
import 'package:biblio/validators/userValidator.dart';
import 'package:biblio/screens/login/signInButton.dart';
import 'package:biblio/services/userServices.dart';

/**
 * TODO: use shared preferences to store the state before
 * the widget is disposed (Screen rotation, app killing or app leaving)
 * 
 * TODO: Check what other lifecycle events should be tracked
 * 
 * TODO: handle http exceptions 
 */

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  
  String username;
  String password;

  final _formKey = GlobalKey<FormState>();
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
                SizedBox(height: 10.0),
                TextInput(
                  obscureText: true,
                  label: "Contraseña",
                  icon: Icons.lock,
                  controller: _passwordController,
                  validator: validatePassword,
                ),                            
                /*RaisedButton(
                  child: Text("Sign in"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Processing data..."),
                      ));
                      var user=await UserServices.signIn(username, password, context);
                      print(user.username+" "+user.isAuthenticated.toString());
                    }
                  },
                ),
                */                
              ],
            ),
          )
        ],
      ),
    );
  }
}
