import 'package:flutter/material.dart';

// TODO: Change this to receive a book instead
class BookThumbnail extends StatelessWidget {
  final String thumbnailUrl;  
  final String heroTag;  
  BookThumbnail({@required this.thumbnailUrl, @required this.heroTag});  

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: FadeInImage(
        // TODO: change default image. Get Network image inside a try catch block
        image: thumbnailUrl!=null ? NetworkImage(thumbnailUrl) : AssetImage('assets/x.jpg'),
        placeholder: AssetImage('assets/x.jpg'),
        height: 90.0,
        width: 90.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
