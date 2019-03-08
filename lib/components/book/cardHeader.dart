import 'package:flutter/material.dart';
import 'package:biblio/models/sections.dart';

class CardHeader extends StatelessWidget {
  final Sections section;
  final Function goToTab;

  CardHeader({@required this.section, this.goToTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            section.type,
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
            onTap: goToTab(section.moreUrl),
          ),
        ],
      ),
    );
  }
}
