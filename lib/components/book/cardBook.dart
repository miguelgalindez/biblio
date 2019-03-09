import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import './bookThumbnail.dart';

class CardBook extends StatelessWidget {
  final Book book;

  CardBook(this.book);

  List<Widget> _getCardChildren(Book book) {
    bool bookHasAuthors = book.authors != null && book.authors.length > 0;
    List<Widget> cardChildren = [
      Text(
        book.title,
        overflow: TextOverflow.ellipsis,
        maxLines: bookHasAuthors ? 2 : 3,
        style: TextStyle(fontSize: 12.0),
      )
    ];

    if (bookHasAuthors) {
      cardChildren.addAll([
        SizedBox(height: 5.0),
        // TODO: Fix this (how to present authors. what if there're many of them?)
        // Which one comes first?
        Text(
          book.authors[0],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic),
        )
      ]);
    }
    return cardChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            //onTap: () => Navigator.pushNamed(context, '/product/' + book.id),
            child: BookThumbnail(
              thumbnailUrl: book.smallThumbnail,
              isbn13: book.isbn13,
              isbn10: book.isbn10,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getCardChildren(book)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
