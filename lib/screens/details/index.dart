import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/hero_photo_viewer.dart';
import 'package:biblio/components/book/bookThumbnail.dart';

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails({Key key, @required this.book}) : super(key: key);

  _thumbnailWithPhotoView(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HeroPhotoViewWrapper(
                        heroTag: book.getId(),
                        imageProvider: NetworkImage(book.thumbnail),
                      )));
        },
        child: Container(
          child: BookThumbnail(
            thumbnailUrl: book.thumbnail,
            heroTag: book.getId(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: _thumbnailWithPhotoView(context),
                      title: Text(
                        book.title,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            // TODO: fix this !!
                            child: Text("Authors...."),
                          ),
                          Text(book.publisher),
                        ],
                      ),
                    ),
                    // TODO: fix this !!
                    Container(child: Text("Another section..."),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
