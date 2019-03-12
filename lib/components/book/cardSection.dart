import 'package:flutter/material.dart';
import './cardBook.dart';
import 'package:biblio/models/book.dart';

class CardSection extends StatelessWidget {
  final List<Book> books;
  CardSection({this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemExtent: 110.0,
        itemBuilder: (BuildContext context, int index) {
          return CardBook(books[index]);
        },
      ),
    );
  }
}
