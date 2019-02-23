import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final DecorationImage image;  

  Logo({Key key, @required this.image}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
      width: 250.0,
      height: 250.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: this.image,
      ),
    );
  }
}