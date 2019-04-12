import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/components/customListTile.dart';
import 'package:biblio/components/clickableChip.dart';
import 'package:biblio/models/appConfig.dart';

class BookAllReviews extends StatelessWidget {
  final Book book;

  BookAllReviews({@required this.book});

  Widget _getRatingWidget(TextStyle ratingTextStyle, Color ratingTextColor) {
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
        trailing: _getRatingWidget(ratingTextStyle, ratingTextColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {    
    Color primaryColor = Theme.of(context).primaryColor;    
    Function onChipTapped = () {
      print("Chip tapped");
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(context),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children: <Widget>[
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      text: "Todas",
                      onTap: onChipTapped,                      
                    ),
                    ClickableChip(
                      clickedBackgroundColor: primaryColor,
                      text: "Positivas",
                      onTap: onChipTapped,
                      clicked: true,
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
