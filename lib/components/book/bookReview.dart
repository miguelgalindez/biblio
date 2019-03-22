import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:biblio/models/book.dart';

class BookReview extends StatelessWidget {
  final Book book;  
  final Color starsColor;
  BookReview({Key key, @required this.book, @required this.starsColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(      
      onTap: () {
        // TODO this has to make the comment full readable
        print("review comment tapped");
      },
      child: Container(
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
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: Text("User icon"),
              title: Text("User name"),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                tooltip: "Acciones",
                onPressed: () {
                  print("Comment's actions button tapped");
                },
              ),
            ),
            Row(
              children: <Widget>[
                SmoothStarRating(
                  size: 16.0,
                  rating: book.averageRating,
                  color: starsColor,
                ),
                // TODO fetch this value from DB
                Text("22/03/2019")
              ],
            ),
            Text(
              // TODO fetch this value from DB
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
