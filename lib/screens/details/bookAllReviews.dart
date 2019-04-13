import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/components/customListTile.dart';
import 'package:biblio/components/clickableChip.dart';

class BookAllReviews extends StatelessWidget {
  final Book book;

  BookAllReviews({@required this.book});

  Widget _getStarWidget(int numberOfStar) {
    return Row(
      children: <Widget>[
        Text(numberOfStar.toString()),
        SizedBox(width: 2),
        Icon(
          Icons.star,
          size: 12.0,
        ),
      ],
    );
  }

  Widget _getBookAverageRatingWidget(
      TextStyle ratingTextStyle, Color ratingTextColor) {
    if (book.averageRating != null) {
      return Row(
        children: <Widget>[
          Text(
            book.averageRating.toString(),
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
          heroTag: book.getId(),
          thumbnailUrl: book.smallThumbnail,
          height: 46.0,
          width: 32.0,
        ),
        title: Text(
          book.title,
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
    Function onChipTapped = () {
      print("Chip tapped");
    };

    const EdgeInsetsGeometry chipLeftMargin = EdgeInsets.only(left: 8.0);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(context),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: Text("Todas"),
                      onTap: onChipTapped,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: Text("Positivas"),
                      onTap: onChipTapped,
                      clicked: true,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: Text("Negativas"),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: _getStarWidget(5),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: _getStarWidget(4),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: _getStarWidget(3),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: _getStarWidget(2),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      child: _getStarWidget(1),
                      onTap: onChipTapped,
                      clicked: false,
                      margin: chipLeftMargin,
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
