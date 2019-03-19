import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/services/acronyms.dart';

class BookStats extends StatelessWidget {
  final Book book;
  BookStats({@required this.book});

  // TODO Test all stats agains null values

  Widget _getStat(List<Widget> headerWidgets, List<Widget> footerWidgets) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: headerWidgets,
        ),
        SizedBox(height: 2.0),
        Row(children: footerWidgets),
      ],
    );
  }

  Widget _getStars(TextStyle headerTextStyle, TextStyle footerTextStyle) {
    double averageRating = book.averageRating;
    int ratingsCount = book.ratingsCount;
    String headerText = averageRating != null ? averageRating.toString() : "";

    List<Widget> headerWidgets = [];
    if (averageRating != null) {
      headerWidgets.addAll([
        Text(headerText, style: headerTextStyle),
        SizedBox(width: 5.0),
      ]);
    }

    headerWidgets.add(Icon(Icons.star));

    String footerText = ratingsCount != null
        ? ratingsCount.toString() + " revisiones"
        : "Sin revisiones";

    List<Widget> footerWidgets = [Text(footerText, style: footerTextStyle)];

    return _getStat(headerWidgets, footerWidgets);
  }

  // TODO: Fix this to get true data from db. Don't forget to handle null data
  Widget _getTimesAsked(TextStyle headerTextStyle, TextStyle footerTextStyle) {
    List<Widget> headerWidgets = [
      Text("12M", style: headerTextStyle),
    ];

    List<Widget> footerWidgets = [Text("veces pedido", style: footerTextStyle)];

    return _getStat(headerWidgets, footerWidgets);
  }

  Widget _getNumberOfPages(TextStyle footerTextStyle) {
    int numberOfPages = book.pageCount;
    if (numberOfPages != null && numberOfPages > 0) {
      String footerText = numberOfPages.toString() + " páginas";
      List<Widget> headerWidgets = [Icon(Icons.content_copy)];

      List<Widget> footerWidgets = [Text(footerText, style: footerTextStyle)];
      return _getStat(headerWidgets, footerWidgets);
    }
    return null;
  }
  
  Widget _getLanguage(TextStyle footerTextStyle) {
    String language = Acronyms.getLanguageFromAcronym(book.language);
    List<Widget> headerWidgets = [Icon(Icons.language)];
    List<Widget> footerWidgets = [Text(language, style: footerTextStyle)];
    return _getStat(headerWidgets, footerWidgets);
  }

  Widget _getDivider() {
    return SizedBox(width: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle headerTextStyle = themeData.textTheme.title.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    TextStyle footerTextStyle =
        themeData.textTheme.caption.copyWith(color: Colors.grey);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getStars(headerTextStyle, footerTextStyle),
          _getDivider(),
          _getTimesAsked(headerTextStyle, footerTextStyle),
          _getDivider(),
          _getNumberOfPages(footerTextStyle),
          _getDivider(),
          _getLanguage(footerTextStyle)
        ].where((widget) => widget != null).toList(),
      ),
    );
  }
}
