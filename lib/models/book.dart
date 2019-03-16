import 'package:biblio/services/jsonHelpers.dart';

class Book {
  final String isbn10;
  final String isbn13;
  final String title;
  final String subtitle;
  final List<String> authors;
  final String publisher;
  final DateTime publishedDate;
  final String description;
  final String language;
  final int pageCount;
  final double averageRating;
  final int ratingsCount;
  final String previewLink;
  final String smallThumbnail;
  final String thumbnail;

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
      });

  // TODO Change this. get id from mongoose db
  String getId(){
    if(isbn13 != null)
      return isbn13;
    else if(isbn10!=null) 
      return isbn10;
    else
    return title;
  } 

  String getInlineAuthors(){
    if(authors!=null && authors.isNotEmpty){
      return authors.join(", ");
    }
    return null;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> bookJson = json['items'][0]['volumeInfo'];

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
    );
  }
}
