import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

List<Category> categories = [];
List<Book> books = [];

Future<List<Category>> getCategories() async {
  if (categories.isEmpty) {
    categories = await loadCategories();
  }
  return categories;
}

List<Book> getBooks() {
  return books;
}

Future<List<Category>> loadCategories() async {
  final jsondata = await json.decode(await rootBundle.loadString("assets/books-mock-data.json"));
  List<Category> array = [];
  books=[];
  
  List<Book> categoryBooks = Category.parseBooks(jsondata, 'tech');

  array.add(Category(
    id: "tech",
    icon: Icons.usb,
    name: "Tecnología",
    books: categoryBooks,
  ));
  books.addAll(categoryBooks);

  categoryBooks = Category.parseBooks(jsondata, 'literature');

  array.add(Category(
    id: "literature",
    icon: Icons.import_contacts,
    name: "Literatura",
    books: categoryBooks,
  ));
  books.addAll(categoryBooks);

  categoryBooks = Category.parseBooks(jsondata, 'arts');

  array.add(Category(
    id: "arts",
    icon: Icons.palette,
    name: "Artes",
    books: categoryBooks,
  ));
  books.addAll(categoryBooks);

  categoryBooks = Category.parseBooks(jsondata, 'sciences');

  array.add(Category(
    id: "sciences",
    icon: Icons.poll, //poll pie_chart
    name: "Ciencias",
    books: categoryBooks,
  ));
  books.addAll(categoryBooks);

  /*
  categories.add(Category(
      id: "philosophy",
      icon: Icons.account_balance,
      name: "Filosofía",
      books: books));
  */

  return array;
}
