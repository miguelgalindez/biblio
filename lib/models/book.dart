class Book {
  final String isbn;
  final String title;
  final String subtitle;
  final String author;
  final DateTime published;
  final String publisher;
  final int pages;
  final String description;
  final String coverUrl;
  final String website;

  Book(
      {this.isbn,
      this.title,
      this.subtitle,
      this.author,
      this.published,
      this.publisher,
      this.pages,
      this.description,
      this.coverUrl,
      this.website});
}
