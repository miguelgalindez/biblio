import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import './bookThumbnail.dart';
import 'package:biblio/screens/details/index.dart';
import 'package:biblio/models/appConfig.dart';

enum CardBookSize { small, medium, big }

class CardBook extends StatelessWidget {
  final Book book;
  final CardBookSize size;

  CardBook({@required this.book, this.size = CardBookSize.small});

  TextStyle _getBookTitleTextStyle() {
    switch (size) {
      case CardBookSize.big:
        return TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
      case CardBookSize.medium:
        return TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
      case CardBookSize.small:
      default:
        return TextStyle(fontSize: 12.0);
    }
  }

  TextStyle _getBookAuthorsTextStyle() {
    switch (size) {
      case CardBookSize.big:
        return TextStyle(fontSize: 14.0);
      case CardBookSize.medium:
        return TextStyle(fontSize: 12.0);
      case CardBookSize.small:
      default:
        return TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic);
    }
  }

  List<Widget> _getCardChildren(Book book) {
    bool bookHasAuthors = book.authors != null && book.authors.length > 0;
    List<Widget> cardChildren = [
      Text(
        book.title,
        textAlign:
            size == CardBookSize.big ? TextAlign.justify : TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: bookHasAuthors ? 2 : 3,
        style: _getBookTitleTextStyle(),
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
          style: _getBookAuthorsTextStyle(),
        )
      ]);
    }
    return cardChildren;
  }

  double _getBookThumbnailSideSize() {
    switch (size) {
      case CardBookSize.medium:
        return 150.0;

      case CardBookSize.big:
        return 200.0;

      case CardBookSize.small:
      default:
        return 90.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double bookThumbnailSideSize = _getBookThumbnailSideSize();
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BookDetails(book: book)));
      },
      splashColor: AppConfig.of(context).secondaryColor,
      child: Container(
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BookThumbnail(
              thumbnailUrl: size == CardBookSize.small
                  ? book.smallThumbnail
                  : book.thumbnail,
              heroTag: book.getId(),
              width: bookThumbnailSideSize,
              height: bookThumbnailSideSize,
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getCardChildren(book)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
