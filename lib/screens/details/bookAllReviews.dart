import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/components/customListTile.dart';
import 'package:biblio/enums/bookReviewsFilter.dart';
import 'package:biblio/screens/details/BookReviewsFiltersBar.dart';

class BookAllReviews extends StatefulWidget {
  final Book book;

  BookAllReviews({@required this.book});

  @override
  _BookAllReviewsState createState() => _BookAllReviewsState();
}

class _BookAllReviewsState extends State<BookAllReviews> {
  BookReviewsFilter filter;

  @override
  void initState() {
    filter = BookReviewsFilter.all;
    super.initState();
  }

  Function changeFilter(BookReviewsFilter newFilter) => () {
        setState(() {
          filter = newFilter != filter ? newFilter : BookReviewsFilter.all;
        });
      };

  Widget _getBookAverageRatingWidget(
      TextStyle ratingTextStyle, Color ratingTextColor) {
    if (widget.book.averageRating != null) {
      return Row(
        children: <Widget>[
          Text(
            widget.book.averageRating.toString(),
            style: ratingTextStyle,
          ),
          SizedBox(width: 2),
          Icon(
            Icons.star,
            size: 12.0,
            color: ratingTextColor,
          ),
        ],
      );
    }
    return null;
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
        trailing: _getBookAverageRatingWidget(ratingTextStyle, ratingTextColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(context),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    BookReviewsFiltersBar(
                      filter: filter,
                      onChangeFilter: changeFilter,
                      clickedBackgroundColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
