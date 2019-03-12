import 'package:flutter/material.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/appConfig.dart';

class CardHeader extends StatelessWidget {
  final Category category;
  final Function goToTab;

  CardHeader({@required this.category, this.goToTab});

//padding: EdgeInsets.only(left: 10.0, top: 20.0),
  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig.of(context);
    return InkWell(
      splashColor: appConfig.secondaryColor,
      child: Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              category.name,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            Text(
              "MÁS",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: appConfig.primaryColor),
            ),
          ],
        ),
      ),
      onTap: () {
        goToTab(category.id);
      },
    );
  }
}
