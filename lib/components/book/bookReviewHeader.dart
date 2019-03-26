import 'package:flutter/material.dart';

class BookReviewHeader extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String title;
  final Function onTapMore;

  BookReviewHeader(
      {@required this.primaryColor,
      @required this.secondaryColor,
      @required this.title,
      @required this.onTapMore});

  final BorderRadius borderRadius = BorderRadius.only(
    topLeft: const Radius.circular(8.0),
    topRight: const Radius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: secondaryColor,
      borderRadius: borderRadius,
      onTap: onTapMore,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: borderRadius,
        ),
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(
              "MÁS",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
