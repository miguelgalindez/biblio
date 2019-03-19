import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';

class BookDescription extends StatelessWidget {
  final Book book;
  BookDescription({@required this.book});

  Widget _getAppbar() {
    // TODO make this a dynamic value (Global state)
    return SliverAppBar(
      expandedHeight: 56.0,
      pinned: false,
      floating: false,
      snap: false,
    );
  }

  static Widget _getTextWidget(
      String text, TextStyle textStyle, TextAlign textAlign, int maxLines) {
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget getIntro(Book book, BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle textStyle =
        themeData.textTheme.subtitle.copyWith(color: Colors.grey);
    TextStyle readMoreButtonTextStyle =
        themeData.textTheme.button.copyWith(color: themeData.primaryColor);

    String text;
    if (book.subtitle != null && book.subtitle.isNotEmpty) {
      text = book.subtitle;
    } else if (book.textSnippet != null && book.textSnippet.isNotEmpty) {
      text = book.textSnippet;
    } else if (book.description != null && book.description.isNotEmpty) {
      text = book.description;
    }

    if (text != null && text.isNotEmpty) {
      return Column(
        children: <Widget>[
          _getTextWidget(text, textStyle, TextAlign.center, 3),
          FlatButton(
            child: Text(
              "Leer más",
              style: readMoreButtonTextStyle,
            ),
            // TODO: add splash (secondary color)
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BookDescription(book: book),
                ),
              );
            },
          )
        ],
      );
    }
    // TODO: Check this null return. What happens? will the app crash?
    return null;
  }

  // TODO: avoid repeated texts
  List<Widget> _getDescriptionTextWidgets() {
    List<Widget> descriptionTextWidgets = [];
    if (book.subtitle != null && book.subtitle.isNotEmpty) {
      descriptionTextWidgets
          .add(_getTextWidget(book.subtitle, null, TextAlign.center, null));
    }

    if (book.description != null && book.description.isNotEmpty) {
      descriptionTextWidgets
          .add(_getTextWidget(book.description, null, TextAlign.justify, null));

    } else if (book.textSnippet != null && book.textSnippet.isNotEmpty) {
      descriptionTextWidgets
          .add(_getTextWidget(book.textSnippet, null, TextAlign.justify, null));
    }

    return descriptionTextWidgets;
  }

  List<Widget> _getBookDescriptionWidgets() {
    return _getDescriptionTextWidgets()
        .where((widget) => widget != null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _getAppbar(),
          SliverToBoxAdapter(
            child: Column(children: _getBookDescriptionWidgets()),
          )
        ],
      ),
    );
  }
}
