import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/models/book.dart';

class AppVariables extends Model {
  User _user;
  final List<Book> _books = [];
  final List<Category> _categories = [];

  AppVariables();

  set user(User user) {
    this.user = user;
  }

  User get user => _user;

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void addBooks(List<Book> books) {
    _books.addAll(books);
    notifyListeners();
  }

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void addCategories(List<Category> categories) {
    _categories.addAll(categories);
    notifyListeners();
  }
}
