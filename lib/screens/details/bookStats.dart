import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';

class BookStats extends StatelessWidget {
  final Book book;
  BookStats({@required this.book});

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
        Row(children: footerWidgets),
      ],
    );
  }

  Widget _getStars(TextStyle textStyle) {
    List<Widget> headerWidgets = [
      Text("4.1", style: textStyle),
      SizedBox(width: 5.0),
      Icon(Icons.star),
    ];

    List<Widget> footerWidgets = [Text("3M revisiones")];
    return _getStat(headerWidgets, footerWidgets);
  }

  Widget _getTimesAsked(TextStyle textStyle) {
    List<Widget> headerWidgets = [
      Text("12M", style: textStyle),
    ];

    List<Widget> footerWidgets = [Text("Veces pedido")];
    return _getStat(headerWidgets, footerWidgets);
  }

  Widget _getNumberOfPages() {
    int numberOfPages = book.pageCount;
    if (numberOfPages != null && numberOfPages > 0) {
      List<Widget> headerWidgets = [
        //Icon(Icons.burst_mode),
        //Icon(Icons.content_copy),
        //Icon(Icons.filter),
        //Icon(Icons.layers),
        Icon(Icons.library_books),
      ];

      List<Widget> footerWidgets = [Text(numberOfPages.toString()+" páginas")];
      return _getStat(headerWidgets, footerWidgets);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle headerTextStyle = themeData.textTheme.title.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _getStars(headerTextStyle),
          SizedBox(width: 24.0),
          _getNumberOfPages(),
          SizedBox(width: 24.0),
          _getTimesAsked(headerTextStyle),
          
        ].where((widget) => widget != null).toList(),
      ),
    );
  }
}
