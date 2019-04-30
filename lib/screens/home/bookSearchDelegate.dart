import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';
import 'package:biblio/models/book.dart';

class BookSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isNotEmpty
        ? [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                query = "";
              },
            )
          ]
        : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        shape: StadiumBorder(),
        child: Center(
          child: Text(
            query,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  TextSpan _buildNormalTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(color: Colors.black),
    );
  }

  TextSpan _buildHighlightedTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }

  RichText _buildBookTitle(Book book) {
    TextSpan textSpan;
    if (query.isNotEmpty) {
      Iterable<Match> matches = book.title.allMatches(query);
      int currentPosition = 0;
      List<TextSpan> fragments=[];

      while (currentPosition < book.title.length && matches.isNotEmpty) {
        Match match = matches.first;

        if (match.start > currentPosition) {
          fragments.add(_buildNormalTextSpan(
              book.title.substring(currentPosition, match.start)));
        }

        fragments.add(_buildHighlightedTextSpan(
            book.title.substring(match.start, match.end + 1)));
        currentPosition = match.end + 1;
      }
      if (currentPosition < book.title.length - 1) {
        fragments.add(_buildNormalTextSpan(
            book.title.substring(currentPosition, book.title.length)));
      }
      textSpan = TextSpan(
        text: fragments[0].text,
        style: fragments[0].style,
        children: fragments.sublist(1),
      );
    } else {
      textSpan = _buildNormalTextSpan(book.title);
    }

    return RichText(text: textSpan);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Book> books = ScopedModel.of<AppVariables>(context).books;
    List<Book> recentBooks = books.sublist(0, 5);
    final suggestionList = query.isEmpty
        ? recentBooks
        : books.where((Book book) => book.title.contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              query = books[index].title;
              showResults(context);
            },
            leading: Icon(Icons.location_city),
            title: _buildBookTitle(books[index]),
          ),
      itemCount: suggestionList.length,
    );
  }
}
