import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(
          image: AssetImage("assets/under-construction.png"),
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
