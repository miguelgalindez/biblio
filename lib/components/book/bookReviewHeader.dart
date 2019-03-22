import 'package:flutter/material.dart';

class BookReviewHeader extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final List<Widget> children;
  final Function onTap;

  BookReviewHeader(
      {@required this.primaryColor,
      @required this.secondaryColor,
      @required this.children,
      @required this.onTap});

  final BorderRadius borderRadius = BorderRadius.only(
    topLeft: const Radius.circular(8.0),
    topRight: const Radius.circular(8.0),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: secondaryColor,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: borderRadius,
        ),
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
