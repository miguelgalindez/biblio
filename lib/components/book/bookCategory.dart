import 'package:flutter/material.dart';
import './bookCard.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/appConfig.dart';

class BookCategory extends StatelessWidget {
  final Category category;
  final Function goToTab;
  BookCategory({@required this.category, @required this.goToTab});

  Widget _buildHeader(BuildContext context) {
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

  Widget _buildBody() {
    return SizedBox(
      height: 150.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.books.length,
        itemExtent: 110.0,
        itemBuilder: (BuildContext context, int index) {
          return BookCard(book: category.books[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            SizedBox(height: 10.0),
            _buildBody(),
          ],
        ),
      ),
    );
  }
}
