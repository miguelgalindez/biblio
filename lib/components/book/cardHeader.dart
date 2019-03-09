import 'package:flutter/material.dart';
import 'package:biblio/models/category.dart';

class CardHeader extends StatelessWidget {
  final Category category;
  final Function goToTab;

  CardHeader({@required this.category, this.goToTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            category.name,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          GestureDetector(
            child: Text(
              "TODOS",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            onTap: goToTab(category.id),
          ),
        ],
      ),
    );
  }
}
