import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/components/customListTile.dart';
import 'package:biblio/components/book/reviews/bookReviewsFiltersBar.dart';
import 'package:biblio/components/listHeader.dart';
import 'package:biblio/components/basicRating.dart';
import 'package:biblio/models/sortingCriteria.dart';
import 'package:biblio/models/review.dart';
import 'package:biblio/components/book/reviews/bookReview.dart';
import 'package:biblio/services/reviews-mock-data.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/components/book/reviews/bookDetailedRating.dart';
import 'package:biblio/components/book/reviews/bookTopReviews.dart';

class BookReviews extends StatefulWidget {
  final Book book;
  final BookReviewsFilter initialFilter;
  final List<SortingCriteria> sortingCriterias = Review.sortingCriterias;

  BookReviews({@required this.book, this.initialFilter});


  // TODO: pick a better name
  static Widget getIntro(Book book, BuildContext context) {
    List<Widget> widgets = [];
    if (book.hasRatings()) {
      TextStyle titleStyle = Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontWeight: FontWeight.bold);

      Widget title, detailedRating, topReviews;

      title = Text(
        "Valoraciones y comentarios",
        textAlign: TextAlign.start,
        style: titleStyle,
      );

      detailedRating = Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: BookDetailedRating(book: book),
      );

      topReviews = BookTopReviews(book: book);

      widgets.add(title);
      widgets.add(detailedRating);
      widgets.add(topReviews);
    }
    
    widgets = widgets.where((widget) => widget != null).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  @override
  _BookReviewsState createState() => _BookReviewsState();
}

class _BookReviewsState extends State<BookReviews> {
  BookReviewsFilter filter;
  SortingCriteria selectedSortingCriteria;

  @override
  void initState() {
    filter = widget.initialFilter != null
        ? widget.initialFilter
        : BookReviewsFilter.all;

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
          trailing: BasicRating(
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
        return BasicRating(
            numberOfStar: 5, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star4:
        return BasicRating(
            numberOfStar: 4, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star3:
        return BasicRating(
            numberOfStar: 3, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star2:
        return BasicRating(
            numberOfStar: 2, iconSize: iconSize, textStyle: titleTextStyle);

      case BookReviewsFilter.star1:
        return BasicRating(
            numberOfStar: 1, iconSize: iconSize, textStyle: titleTextStyle);

      default:
        return null;
    }
  }

  List<Review> _filterReviews() {
    List<Review> allReviews = getAllReviews();
    switch (filter) {
      case BookReviewsFilter.all:
        return allReviews;

      case BookReviewsFilter.positive:
        return allReviews.where((review) => review.rating >= 3.0).toList();

      case BookReviewsFilter.negative:
        return allReviews.where((review) => review.rating < 3.0).toList();

      case BookReviewsFilter.star5:
        return allReviews.where((review) => review.rating == 5.0).toList();

      case BookReviewsFilter.star4:
        return allReviews
            .where((review) => review.rating >= 4.0 && review.rating < 5.0)
            .toList();

      case BookReviewsFilter.star3:
        return allReviews
            .where((review) => review.rating >= 3.0 && review.rating < 4.0)
            .toList();

      case BookReviewsFilter.star2:
        return allReviews
            .where((review) => review.rating >= 2.0 && review.rating < 3.0)
            .toList();

      case BookReviewsFilter.star1:
        return allReviews
            .where((review) => review.rating >= 1.0 && review.rating < 2.0)
            .toList();

      default:
        return allReviews;
    }
  }

  // TODO: make a widget to indicate that there's no results for the applied filter
  List<Widget> _buildReviewsList(Color primaryColor, Color secondaryColor) {
    List<Review> filteredReviews = _filterReviews();
    List<Widget> reviewsWidgets = [];
    filteredReviews.forEach((Review review) {
      reviewsWidgets.add(BookReview(
        review: review,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ));
    });

    return reviewsWidgets;
  }

  List<Widget> _buildWidgets(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    AppConfig appConfig = AppConfig.of(context);
    Color primaryColor = appConfig.primaryColor;
    Color secondaryColor = appConfig.secondaryColor;
    List<Widget> widgets = [];

    Widget filterBar = BookReviewsFiltersBar(
      filter: filter,
      onChangeFilter: changeFilter,
      clickedBackgroundColor: primaryColor,
    );

    Widget header = ListHeader(
      title: _getListHeaderTitle(themeData),
      selectedSortingCriteria: selectedSortingCriteria,
      sortingCriterias: widget.sortingCriterias,
      onSortingCriteriaChage: changeSortingCriteria,
    );

    List<Widget> reviewsWidgets =
        _buildReviewsList(primaryColor, secondaryColor);

    widgets.add(filterBar);
    widgets.add(header);
    widgets.addAll(reviewsWidgets);

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildWidgets(context),
            ),
          ),
        ],
      ),
    );
  }
}
