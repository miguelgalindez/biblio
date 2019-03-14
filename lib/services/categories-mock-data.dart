import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/book.dart';
import 'dart:convert';

Future<List<Category>> getCategories(context) async {
  final jsondata = await json.decode(await DefaultAssetBundle.of(context)
      .loadString("assets/books-mock-data.json"));
  List<Category> categories = [];

  List<Book> books = Category.parseBooks(jsondata, 'tech');

  categories.add(Category(
    id: "tech",
    icon: Icons.usb,
    name: "Tecnología",
    books: books,
  ));

  books = Category.parseBooks(jsondata, 'literature');

  categories.add(Category(
      id: "literature",
      icon: Icons.import_contacts,
      name: "Literatura",
      books: books));

  books = Category.parseBooks(jsondata, 'arts');

  categories.add(Category(
    id: "arts",
    icon: Icons.palette,
    name: "Artes",
    books: books,
  ));

  books = Category.parseBooks(jsondata, 'sciences');

  categories.add(Category(
      id: "sciences",
      icon: Icons.poll, //poll pie_chart
      name: "Ciencias",
      books: books));

  /*
  categories.add(Category(
      id: "philosophy",
      icon: Icons.account_balance,
      name: "Filosofía",
      books: books));
  */

  return categories;
}
