import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/components/customListTile.dart';
import 'package:biblio/enums/bookReviewsFilter.dart';
import 'package:biblio/screens/details/BookReviewsFiltersBar.dart';
import 'package:biblio/components/listHeader.dart';
import 'package:biblio/components/rating.dart';
import 'package:biblio/models/sortingCriteria.dart';
import 'package:biblio/models/review.dart';

class BookAllReviews extends StatefulWidget {
  final Book book;
  final List<SortingCriteria> sortingCriterias = Review.sortingCriterias;

  BookAllReviews({@required this.book});

  @override
  _BookAllReviewsState createState() => _BookAllReviewsState();
}

class _BookAllReviewsState extends State<BookAllReviews> {
  BookReviewsFilter filter;
  SortingCriteria selectedSortingCriteria;

  @override
  void initState() {
    filter = BookReviewsFilter.all;
    if (widget.sortingCriterias != null && widget.sortingCriterias.isNotEmpty) {
      selectedSortingCriteria = widget.sortingCriterias[0];
    }
    super.initState();
  }

  Function changeFilter(BookReviewsFilter newFilter) => () {
        setState(() {
          filter = newFilter != filter ? newFilter : BookReviewsFilter.all;
        });
      };

  void changeSortingCriteria(SortingCriteria criteria) {
    setState(() {
      selectedSortingCriteria = criteria;
    });
  }

  Widget _getAppBar(BuildContext context) {
    Color ratingTextColor = Colors.white;
    TextStyle titleTextStyle =
        CustomListTile.getSuggestedTextStyleForTitle(context);
    TextStyle ratingTextStyle = titleTextStyle.copyWith(color: ratingTextColor);
    TextStyle subTitleTextStyle =
        CustomListTile.getSuggestedTextStyleForSubtitle(context);

    return SliverAppBar(
      expandedHeight: 56.0,
      elevation: 8.0,
      forceElevated: true,
      pinned: false,
      floating: true,
      snap: false,
      centerTitle: false,
      titleSpacing: 0.0,
      title: CustomListTile(
          leading: BookThumbnail(
            heroTag: widget.book.getId(),
            thumbnailUrl: widget.book.smallThumbnail,
            height: 46.0,
            width: 32.0,
          ),
          title: Text(
            widget.book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleTextStyle,
          ),
          subtitle: Text(
            "Revisiones y calificaciones",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: subTitleTextStyle,
          ),
          trailing: Rating(
            numberOfStar: widget.book.averageRating,
            textStyle: ratingTextStyle,
            iconColor: ratingTextColor,
            iconSize: 15.0,
          )),
    );
  }

  Widget _getListHeaderTitle(ThemeData themeData) {
    double iconSize = 15.0;
    TextStyle titleTextStyle = themeData.textTheme.subhead;

    switch (filter) {
      case BookReviewsFilter.all:
        return Text('Todas', style: titleTextStyle);

      case BookReviewsFilter.positive:
        return Text('Positivas', style: titleTextStyle);

      case BookReviewsFilter.negative:
        return Text('Negativas', style: titleTextStyle);

      case BookReviewsFilter.star5:
        return Rating(
            numberOfStar: 5, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star4:
        return Rating(
            numberOfStar: 4, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star3:
        return Rating(
            numberOfStar: 3, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star2:
        return Rating(
            numberOfStar: 2, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star1:
        return Rating(
            numberOfStar: 1, iconSize: iconSize, textStyle: titleTextStyle);

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color primaryColor = themeData.primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                BookReviewsFiltersBar(
                  filter: filter,
                  onChangeFilter: changeFilter,
                  clickedBackgroundColor: primaryColor,
                ),
                ListHeader(
                  title: _getListHeaderTitle(themeData),
                  selectedSortingCriteria: selectedSortingCriteria,
                  sortingCriterias: widget.sortingCriterias,
                  onSortingCriteriaChage: changeSortingCriteria,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
