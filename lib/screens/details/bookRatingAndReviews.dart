import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BookRatingAndReviews extends StatelessWidget {
  final Book book;
  BookRatingAndReviews({@required this.book});

  Widget _getRatingByStar(int star, double percent, BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(star.toString()),
          ],
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

  Widget _getRatingWidgets(
      BuildContext context, ThemeData themeData, AppConfig appConfig) {
    TextStyle averageRatingTextStyle =
        themeData.textTheme.display2.copyWith(color: Colors.black);
    TextStyle ratingsCountTextStyle =
        themeData.textTheme.body1.copyWith(color: Colors.grey);

    List<Widget> widgets = [];
    if (book.averageRating != null &&
        book.ratingsCount != null &&
        book.ratingsCount > 0) {
      Widget averageRatingWidget = Flexible(
        flex: 1,
        fit: FlexFit.loose,
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
      if (appConfig.projectStage.toLowerCase() == 'dev') {
        Widget ratingByStarsWidget = Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _getRatingByStar(5, 0.6, context),
                _getRatingByStar(4, 0.3, context),
                _getRatingByStar(3, 0.1, context),
                _getRatingByStar(2, 0.05, context),
                _getRatingByStar(1, 0.05, context),
              ],
            ),
          ),
        );
        widgets.add(ratingByStarsWidget);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    AppConfig appConfig = AppConfig.of(context);
    TextStyle titleStyle = themeData.textTheme.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Calificaciones y comentarios",
          textAlign: TextAlign.start,
          style: titleStyle,
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: _getRatingWidgets(context, themeData, appConfig),
        ),
      ],
    );
  }
}
