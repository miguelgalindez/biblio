import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final AssetImage image;
  final double height;
  final double width;

  Logo({Key key, @required this.image, this.height = 200.0, this.width = 200.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Image(height: height, width: width, image: image),
    );
  }
}
