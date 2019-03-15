import 'package:flutter/material.dart';
import 'package:biblio/components/book/cardBook.dart';
import 'package:biblio/models/category.dart';

class SecondaryTabView extends StatelessWidget {
  final Category category;

  SecondaryTabView({@required this.category});

  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(5.0),
      physics: ClampingScrollPhysics(),
      itemCount: category.books.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // TODO make this a parameter
          maxCrossAxisExtent: 110.0,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          // TODO make this dynamic
          childAspectRatio: 0.55),
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
            height: 150.0, child: CardBook(book: category.books[index]));
      },
    );
  }
}
