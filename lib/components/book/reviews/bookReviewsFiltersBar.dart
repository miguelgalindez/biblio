import 'package:flutter/material.dart';
import 'package:biblio/components/clickableChip.dart';
import 'package:biblio/components/basicRating.dart';
import 'package:biblio/models/review.dart';

class BookReviewsFiltersBar extends StatelessWidget {
  final BookReviewsFilter filter;
  final Function onChangeFilter;
  final Color clickedBackgroundColor;
  final EdgeInsetsGeometry chipLeftMargin = const EdgeInsets.only(left: 6.0);

  BookReviewsFiltersBar(
      {@required this.filter,
      @required this.onChangeFilter,
      this.clickedBackgroundColor});  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),      
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
            children: <Widget>[
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: Text("Todas"),
                onTap: onChangeFilter(BookReviewsFilter.all),
                clicked: filter == BookReviewsFilter.all,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: Text("Positivas"),
                onTap: onChangeFilter(BookReviewsFilter.positive),
                clicked: filter == BookReviewsFilter.positive,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: Text("Negativas"),
                onTap: onChangeFilter(BookReviewsFilter.negative),
                clicked: filter == BookReviewsFilter.negative,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: BasicRating(numberOfStar: 5),
                onTap: onChangeFilter(BookReviewsFilter.star5),
                clicked: filter == BookReviewsFilter.star5,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: BasicRating(numberOfStar: 4),
                onTap: onChangeFilter(BookReviewsFilter.star4),
                clicked: filter == BookReviewsFilter.star4,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: BasicRating(numberOfStar: 3),
                onTap: onChangeFilter(BookReviewsFilter.star3),
                clicked: filter == BookReviewsFilter.star3,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: BasicRating(numberOfStar: 2),
                onTap: onChangeFilter(BookReviewsFilter.star2),
                clicked: filter == BookReviewsFilter.star2,
                margin: chipLeftMargin,
              ),
              ClickableChip(
                clickedBackgroundColor: clickedBackgroundColor,
                child: BasicRating(numberOfStar: 1),
                onTap: onChangeFilter(BookReviewsFilter.star1),
                clicked: filter == BookReviewsFilter.star1,
                margin: chipLeftMargin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
