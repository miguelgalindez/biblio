import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookDetailedRating.dart';
import 'package:biblio/components/book/bookTopReviews.dart';

class BookRatingAndReviews extends StatelessWidget {
  final Book book;
  BookRatingAndReviews({@required this.book});

  List<Widget> _buildWidgets(BuildContext context) {
    List<Widget> widgets = [];
    if (book.hasRatings()) {      
      
      TextStyle titleStyle =
          Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold);

      Widget title, detailedRating, topReviews;

      title=Text(
          "Valoraciones y comentarios",
          textAlign: TextAlign.start,
          style: titleStyle,
        );

      detailedRating=Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: BookDetailedRating(book: book),
        );

      topReviews=BookTopReviews(book: book);

      widgets.add(title);
      widgets.add(detailedRating);
      widgets.add(topReviews);
    }
    return widgets.where((widget) => widget != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildWidgets(context),
    );
  }
}
