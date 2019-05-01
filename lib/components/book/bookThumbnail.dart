import 'package:flutter/material.dart';

// TODO: Change this to receive a book instead
class BookThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final String heroTag;
  final double width;
  final double height;
  BookThumbnail(
      {@required this.thumbnailUrl,
      this.heroTag,
      this.width = 90.0,
      this.height = 90.0});

  @override
  Widget build(BuildContext context) {
    Widget image = FadeInImage(
      alignment: Alignment.center,
      // TODO: change default image. Get Network image inside a try catch block
      image: thumbnailUrl != null
          ? NetworkImage(thumbnailUrl)
          : AssetImage('assets/x.jpg'),
      placeholder: AssetImage('assets/x.jpg'),
      height: height,
      width: width,
      fit: BoxFit.contain,
    );

    return heroTag != null ? Hero(tag: heroTag, child: image) : image;
  }
}
