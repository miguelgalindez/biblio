import 'package:flutter/material.dart';
import 'package:biblio/components/clickableChip.dart';
import 'package:biblio/enums/bookReviewsFilter.dart';

class BookReviewsFiltersBar extends StatelessWidget {
  final BookReviewsFilter filter;
  final Function onChangeFilter;
  final Color clickedBackgroundColor;
  final EdgeInsetsGeometry chipLeftMargin = const EdgeInsets.only(left: 6.0);

  BookReviewsFiltersBar({@required this.filter, @required this.onChangeFilter, this.clickedBackgroundColor});

  

  Widget _getStarChip(int numberOfStar) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        children: <Widget>[
          Text(numberOfStar.toString()),
          SizedBox(width: 2),
          Icon(
            Icons.star,
            size: 12.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: _getStarChip(5),
          onTap: onChangeFilter(BookReviewsFilter.star5),
          clicked: filter == BookReviewsFilter.star5,
          margin: chipLeftMargin,
        ),
        ClickableChip(
          clickedBackgroundColor: clickedBackgroundColor,
          child: _getStarChip(4),
          onTap: onChangeFilter(BookReviewsFilter.star4),
          clicked: filter == BookReviewsFilter.star4,
          margin: chipLeftMargin,
        ),
        ClickableChip(
          clickedBackgroundColor: clickedBackgroundColor,
          child: _getStarChip(3),
          onTap: onChangeFilter(BookReviewsFilter.star3),
          clicked: filter == BookReviewsFilter.star3,
          margin: chipLeftMargin,
        ),
        ClickableChip(
          clickedBackgroundColor: clickedBackgroundColor,
          child: _getStarChip(2),
          onTap: onChangeFilter(BookReviewsFilter.star2),
          clicked: filter == BookReviewsFilter.star2,
          margin: chipLeftMargin,
        ),
        ClickableChip(
          clickedBackgroundColor: clickedBackgroundColor,
          child: _getStarChip(1),
          onTap: onChangeFilter(BookReviewsFilter.star1),
          clicked: filter == BookReviewsFilter.star1,
          margin: chipLeftMargin,
        ),
      ],
    );
  }
}
