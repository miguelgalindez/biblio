import 'package:flutter/material.dart';

// TODO: Change this to receive a book instead
class BookThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  final String isbn10;
  final String isbn13;
  BookThumbnail({@required this.thumbnailUrl, this.isbn10, this.isbn13})
  :assert(isbn13!=null || isbn10!=null);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: isbn13!=null ? isbn13 :isbn10,
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
