import 'package:flutter/material.dart';
import 'package:biblio/components/book/bookCategory.dart';
import 'package:biblio/models/category.dart';

class MainTabView extends StatelessWidget {
  final Function goToTab;
  final List<Category> categories;

  MainTabView({@required this.goToTab, @required this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      physics: ClampingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return BookCategory(category: categories[index], goToTab: goToTab);
      },
    );
  }
}
