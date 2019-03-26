import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:biblio/components/book/bookReviewHeader.dart';
import 'package:biblio/models/review.dart';

class BookReview extends StatelessWidget {
  final Review review;
  final String headerTitle;
  final Function headerOnTapMore;
  final Color primaryColor;
  final Color secondaryColor;
  BookReview(
      {Key key,
      @required this.review,
      this.headerTitle,
      this.headerOnTapMore,
      @required this.primaryColor,
      @required this.secondaryColor})
      : super(key: key);

  Widget _getUserPhoto() {
    if (review.user.photo != null && review.user.photo.isNotEmpty) {
      // TODO: use network image to fetch from remote service
      return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(review.user.photo),
          ),
        ),
      );
    }
    return Icon(Icons.person);
  }

  Widget _getReviewListTile() {
    if (review.user != null) {
      return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: _getUserPhoto(),
        ),
        title: Text(
          review.user.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerRight,
          icon: const Icon(Icons.more_vert),
          tooltip: "Acciones",
          splashColor: secondaryColor,
          onPressed: () {
            print("Comment's actions button tapped");
          },
        ),
      );
    }
    return ListTile();
  }

  Widget _getReviewDetails() {
    List<Widget> widgets = [];
    if (review.rating != null || review.date != null) {
      if (review.rating != null) {
        widgets.add(SmoothStarRating(
          size: 16.0,
          rating: review.rating,
          color: primaryColor,
        ));
      }

      if (review.date != null) {
        widgets.add(Text(review.date.toString()));
      }
    }
    return Row(children: widgets);
  }

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    if ((headerTitle != null && headerTitle.isNotEmpty) ||
        headerOnTapMore != null) {
      widgets.add(BookReviewHeader(
        title: headerTitle,
        onTapMore: headerOnTapMore,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ));
    }

    widgets.add(
      Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(8.0),
            bottomRight: const Radius.circular(8.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _getReviewListTile(),
            _getReviewDetails(),
            Text(
              review.comment ?? '',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );

    return widgets.where((widget) => widget != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: This widget must receive a review instead of a book.
    // If review is null, then nothing must be displayed
    return GestureDetector(
      onTap: () {
        // TODO this has to make the comment full readable
        print("review comment tapped");
      },
      child: Column(
        children: _getWidgets(),
      ),
    );
  }
}
