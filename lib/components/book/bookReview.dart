import 'package:flutter/material.dart';
import 'package:biblio/models/review.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class BookReview extends StatelessWidget {
  final Review review;
  final Color primaryColor;
  final Color secondaryColor;  
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  BookReview(
      {@required this.primaryColor,
      @required this.secondaryColor,
      @required this.review});

  final BorderRadius borderRadius = BorderRadius.only(
    topLeft: const Radius.circular(8.0),
    topRight: const Radius.circular(8.0),
  );


  Widget _getUserPhoto() {
    if (review.user.photo != null && review.user.photo.isNotEmpty) {
      return Container(
        height: 40.0,
        width: 40.0,
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            // TODO: use network image to fetch from remote service
            image: AssetImage(review.user.photo),
          ),
        ),
      );
    } else {
      return Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
        ),
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _getReviewListTile(BuildContext context) {
    if (review.user != null) {
      TextStyle nameTextStyle = Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontWeight: FontWeight.bold);
      return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        leading: _getUserPhoto(),
        title: Text(
          review.user.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nameTextStyle,
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

  Widget _getReviewDetails(BuildContext context) {
    List<Widget> widgets = [];
    if (review.rating != null || review.date != null) {
      if (review.rating != null) {
        widgets.add(SmoothStarRating(
          size: 16.0,
          rating: review.rating,
          color: primaryColor,
        ));
      }
      widgets.add(SizedBox(width: 12.0));
      if (review.date != null) {
        widgets.add(Text(dateFormat.format(review.date), style: Theme.of(context).textTheme.caption,));
      }
    }
    return Row(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _getReviewListTile(context),
            SizedBox(height: 6.0),
            _getReviewDetails(context),
            SizedBox(height: 12.0),
            Text(
              review.comment ?? '',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      );
  }
}
