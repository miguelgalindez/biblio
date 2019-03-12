import 'package:flutter/material.dart';
import 'package:biblio/components/book/cardHeader.dart';
import 'package:biblio/components/book/cardSection.dart';
import 'package:biblio/models/category.dart';

class MainTabView extends StatelessWidget {
  final Function goToTab;
  final List<Category> categories;

  MainTabView({@required this.goToTab, @required this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      physics: ClampingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0))),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(children: <Widget>[
              CardHeader(category: categories[index], goToTab: goToTab),
              SizedBox(height: 10.0),
              CardSection(
                books: categories[index].books,
              ),
            ]),
          ),
        );
      },
    );
  }
}
