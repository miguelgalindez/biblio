import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:biblio/components/book/bookReview.dart';
import 'package:biblio/components/book/bookReviewHeader.dart';

class BookRatingAndReviews extends StatelessWidget {
  final Book book;
  BookRatingAndReviews({@required this.book});

  bool _bookHasRatings() {
    return book.averageRating != null &&
        book.ratingsCount != null &&
        book.ratingsCount > 0;
  }

  bool _bookHasRatingByStars() {
    // TODO: get this value from book
    return true;
  }

  bool _bookHasComments() {
    // TODO: get this value from book
    return true;
  }

  Widget _getRatingProgressBar(int star, double percent, BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 6.0),
          child: Column(
            children: <Widget>[
              Text(star.toString()),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return LinearPercentIndicator(
                    percent: percent,
                    progressColor: themeData.primaryColor,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    lineHeight: 10.0,
                    width: constraints.maxWidth,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getRatingWidget(
      BuildContext context, ThemeData themeData, AppConfig appConfig) {
    TextStyle averageRatingTextStyle =
        themeData.textTheme.display3.copyWith(color: Colors.black);
    TextStyle ratingsCountTextStyle =
        themeData.textTheme.body1.copyWith(color: Colors.grey);

    List<Widget> widgets = [];
    if (_bookHasRatings()) {
      Widget averageRatingWidget = Expanded(
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
              borderColor: themeData.primaryColor,
              color: themeData.primaryColor,
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

      widgets.add(averageRatingWidget);

      // TODO: make this dynamic. Watch if the book has the values
      if (_bookHasRatingByStars()) {
        Widget ratingByStarsWidget = Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _getRatingProgressBar(5, 0.6, context),
              _getRatingProgressBar(4, 0.3, context),
              _getRatingProgressBar(3, 0.1, context),
              _getRatingProgressBar(2, 0.05, context),
              _getRatingProgressBar(1, 0.05, context),
            ],
          ),
        );
        widgets.add(ratingByStarsWidget);
      }
    }

    if (widgets.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      );
    }

    return null;
  }

  List<Widget> _getCommentsWidgets(AppConfig appConfig) {
    List<Widget> widgets = [];

    Widget topPositiveReviewWidget = Column(
      children: [
        BookReviewHeader(
          primaryColor: appConfig.primaryColor,
          secondaryColor: appConfig.secondaryColor,
          onTap: () {
            print("More positive reviews tapped");
          },
          children: <Widget>[
            Text("Top positive review"),
            Text(
              "MÁS",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: appConfig.primaryColor,
              ),
            ),
          ],
        ),
        BookReview(
          book: book,
          starsColor: appConfig.primaryColor,
        ),
      ],
    );
    widgets.add(topPositiveReviewWidget);
    return widgets;
  }

  List<Widget> _getWidgets(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    AppConfig appConfig = AppConfig.of(context);
    TextStyle titleStyle = themeData.textTheme.subtitle;

    List<Widget> widgets = [];

    if (_bookHasRatings() || _bookHasComments()) {
      widgets.add(
        Text(
          "Calificaciones y comentarios",
          textAlign: TextAlign.start,
          style: titleStyle,
        ),
      );

      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: _getRatingWidget(context, themeData, appConfig),
        ),
      );

      widgets.addAll(_getCommentsWidgets(appConfig));
    }
    return widgets.where((widget) => widget != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getWidgets(context),
    );
  }
}
