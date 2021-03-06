import 'package:biblio/services/jsonHelpers.dart';

class Book {
  String isbn10;
  String isbn13;
  String title;
  String subtitle;
  List<String> authors;
  String publisher;
  DateTime publishedDate;
  String description;
  String language;
  int pageCount;
  double averageRating;
  int ratingsCount;
  String previewLink;
  String smallThumbnail;
  String thumbnail;
  String textSnippet;

  Book(
      {this.isbn10,
      this.isbn13,
      this.title,
      this.subtitle,
      this.authors,
      this.publisher,
      this.publishedDate,
      this.description,
      this.language,
      this.pageCount,
      this.averageRating,
      this.ratingsCount,
      this.previewLink,
      this.smallThumbnail,
      this.thumbnail,
      this.textSnippet});

  // TODO Change this. get id from mongoose db
  String getId() {
    if (isbn13 != null)
      return isbn13;
    else if (isbn10 != null)
      return isbn10;
    else
      return title;
  }

  String getInlineAuthors() {
    if (authors != null && authors.isNotEmpty) {
      return authors.join(", ");
    }
    return null;
  }

  bool hasRatings() {
    return averageRating != null &&
        ratingsCount != null &&
        ratingsCount > 0;
  }

  bool hasRatingByStars() {
    // TODO: get this value from book
    return true;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> bookJson = json['items'][0]['volumeInfo'];
    Map<String, dynamic> searchInfo = json['items'][0]['searchInfo'];

    String isbn10, isbn13;
    List<dynamic> identifiers = bookJson['industryIdentifiers'];
    if (identifiers != null) {
      identifiers.forEach((identifier) {
        if (identifier['type'] == "ISBN_10") {
          isbn10 = identifier['identifier'];
        } else if (identifier['type'] == "ISBN_13") {
          isbn13 = identifier['identifier'];
        }
      });
    }

    Map<String, dynamic> imageLinks = bookJson['imageLinks'];

    return Book(
      isbn10: isbn10,
      isbn13: isbn13,
      title: bookJson['title'],
      subtitle: bookJson['subtitle'],
      authors: JsonHelpers.parseListOfString(bookJson['authors']),
      publisher: bookJson['publisher'],
      publishedDate: JsonHelpers.parseDateTime(bookJson['publishedDate']),
      description: bookJson['description'],
      language: bookJson['language'],
      // TODO: watch out !! What happens if here comes a null?
      pageCount: bookJson['pageCount'],
      averageRating: bookJson['averageRating'],
      ratingsCount: bookJson['ratingsCount'],
      previewLink: bookJson['previewLink'],

      smallThumbnail: imageLinks != null ? imageLinks['smallThumbnail'] : null,
      thumbnail: imageLinks != null ? imageLinks['thumbnail'] : null,

      textSnippet: searchInfo != null ? searchInfo['textSnippet'] : null,
    );
  }
}
