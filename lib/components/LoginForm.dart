import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(        
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  validator: (value){
                    if(value.isEmpty){
                      return "Please, enter some text";
                    }
                  },
                ),
                Container(
                  width: 320.0,
                  height: 60.0,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(166, 22, 24, 1.0),
                    borderRadius: BorderRadius.all(const Radius.circular(15.0))
                  ),
                  child: Text("Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3
                    ),
                  ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
