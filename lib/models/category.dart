import 'package:flutter/material.dart';
import './book.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final List<Book> books;

  Category({this.id, this.name, this.icon, this.books});

  static List<Book> parseBooks(Map<String, dynamic> booksCollectionJson, String categoryId) {
    return (booksCollectionJson[categoryId] as List).map((bookJson) {
      Book book = Book.fromJson(bookJson);
      if (book.isbn10 == null && book.isbn13 == null) {
        print("Book without id " + book.title);
        return null;
      } else {
        return book;
      }
    }).toList();
  }
}
