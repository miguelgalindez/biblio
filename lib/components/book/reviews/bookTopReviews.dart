import 'package:flutter/material.dart';
import 'package:biblio/components/book/reviews/bookReview.dart';
import 'package:biblio/services/reviews-mock-data.dart';
import 'package:biblio/screens/bookDetails/bookReviews.dart';
import 'package:biblio/models/review.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/models/appConfig.dart';

class BookTopReviews extends StatelessWidget {
  final Book book;
  BookTopReviews({@required this.book});

  final BorderRadius borderRadius = BorderRadius.only(
    topLeft: const Radius.circular(8.0),
    topRight: const Radius.circular(8.0),
  );

  Widget _buildTopReviewHeader(String title, Function onTapMore,
      TextStyle titleTextStyle, Color primaryColor, Color secondaryColor) {
    return InkWell(
      splashColor: secondaryColor,
      borderRadius: borderRadius,
      onTap: onTapMore,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: borderRadius,
        ),
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleTextStyle,
            ),
            Text(
              "MÁS",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Function forwardToMoreReviews(
      BookReviewsFilter filter, BuildContext context) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BookReviews(
                    book: book,
                    initialFilter: filter,
                  )));
    };
  }

  List<Widget> _buildWidgets(BuildContext context, AppConfig appConfig) {
    Color primaryColor = appConfig.primaryColor;
    Color secondaryColor = appConfig.secondaryColor;
    TextStyle titleTextStyle = Theme.of(context)
        .textTheme
        .subtitle
        .copyWith(fontWeight: FontWeight.bold);

    List<Widget> widgets = [];

    Widget topPositiveReviewHeader,
        topPositiveReviewBody,
        topNegativeReviewHeader,
        topNegativeReviewBody;

    // TODO: check top positive review is not null
    topPositiveReviewHeader = _buildTopReviewHeader(
        "Valoración más alta",
        forwardToMoreReviews(BookReviewsFilter.positive, context),
        titleTextStyle,
        primaryColor,
        secondaryColor);

    topPositiveReviewBody = BookReview(
      review: getTopPositiveReview(),
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );

    // TODO: check top negative review is not null
    topNegativeReviewHeader = _buildTopReviewHeader(
        "Valoración más baja",
        forwardToMoreReviews(BookReviewsFilter.negative, context),
        titleTextStyle,
        primaryColor,
        secondaryColor);
        
    topNegativeReviewBody = BookReview(
      review: getTopNegativeReview(),
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );

    widgets.add(SizedBox(height: 24.0));
    widgets.add(topPositiveReviewHeader);
    widgets.add(topPositiveReviewBody);
    widgets.add(SizedBox(height: 24.0));
    widgets.add(topNegativeReviewHeader);
    widgets.add(topNegativeReviewBody);

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    return Column(children: _buildWidgets(context, appConfig));
  }
}
