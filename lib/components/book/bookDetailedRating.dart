import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:biblio/components/ratingProgressBar.dart';

class BookDetailedRating extends StatelessWidget {
  final Book book;

  BookDetailedRating({@required this.book});

  Widget _buildAverageRatingWidget(TextTheme textTheme, Color primaryColor) {
    if (book.hasRatings()) {
      TextStyle averageRatingTextStyle =
          textTheme.display3.copyWith(color: Colors.black);
      TextStyle ratingsCountTextStyle =
          textTheme.body1.copyWith(color: Colors.grey);

      return Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              book.averageRating.toString(),
              style: averageRatingTextStyle,
              textAlign: TextAlign.center,
            ),
            SmoothStarRating(
              rating: book.averageRating,
              starCount: 5,
              allowHalfRating: false,
              borderColor: primaryColor,
              color: primaryColor,
              size: 16.0,
            ),
            Text(
              book.ratingsCount.toString(),
              style: ratingsCountTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return null;
  }

  Widget _buildRatingByStars(Color primaryColor) {
    // TODO: make this dynamic. Watch if the book has the values
    if (book.hasRatingByStars()) {
      return Expanded(
        flex: 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RatingProgressBar(starNumber: 5, percent: 0.6, primaryColor: primaryColor),
            RatingProgressBar(starNumber: 4, percent: 0.1, primaryColor: primaryColor),
            RatingProgressBar(starNumber: 3, percent: 0.2, primaryColor: primaryColor),
            RatingProgressBar(starNumber: 2, percent: 0.07, primaryColor: primaryColor),
            RatingProgressBar(starNumber: 1, percent: 0.03, primaryColor: primaryColor),
          ],
        ),
      );
    }
    return null;
  }

  Widget _buildWidgets(BuildContext context) {
    List<Widget> widgets = [];
    
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    Color primaryColor = themeData.primaryColor;

    Widget averageRatingWidget =
        _buildAverageRatingWidget(textTheme, primaryColor);

    Widget ratingByStars = _buildRatingByStars(primaryColor);

    widgets.add(averageRatingWidget);
    widgets.add(ratingByStars);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets.where((widget) => widget != null).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidgets(context);
  }
}
