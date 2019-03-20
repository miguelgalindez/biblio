import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/simpleListTile.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:url_launcher/url_launcher.dart';


class BookDescription extends StatelessWidget {
  final Book book;
  final DateFormat dateFormat;
  BookDescription({@required this.book})
      : dateFormat = DateFormat("dd/MM/yyyy");

  Widget _getAppbar() {
    // TODO make this a dynamic value (Global state)
    return SliverAppBar(
      expandedHeight: 56.0,
      pinned: false,
      floating: true,
      snap: false,
      centerTitle: false,
      titleSpacing: 0.0,
      title: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        leading: BookThumbnail(
          heroTag: book.getId(),
          thumbnailUrl: book.smallThumbnail,
          height: 46.0,
          width: 32.0,
        ),
        title: Text(book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white)),
      ),
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
    // TODO: if there's no text then call _getMoreInfoWidgets to know if there are
    // some info about the book. In that case, display the button with the message "ver detalles"
    // otherwise, return null to not render the button.
    if (text != null && text.isNotEmpty) {
      return Column(
        children: <Widget>[
          Text(text,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
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
  // TODO: split text in multiple paragraphs based on length
  Widget _getDescriptionTextWidget() {
    String description = "";
    if (book.subtitle != null && book.subtitle.isNotEmpty) {
      description += book.subtitle + "\n\n";
    }
    if (book.description != null && book.description.isNotEmpty) {
      description += book.description;
    } else if (book.textSnippet != null && book.textSnippet.isNotEmpty) {
      description += book.textSnippet;
    }

    if (description != null && description.isNotEmpty) {
      return Text(
        description,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.grey[800],
        ),
      );
    }
    return null;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // TODO: Show an error message
      throw 'Could not launch $url';
    }
  }

  List<Widget> _getMoreInfoWidgets(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    Color iconColor = appConfig.primaryColor;
    double iconSize = 32.0;
    TextStyle titleStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle subtitleStyle = TextStyle(color: Colors.grey);

    List<Widget> widgets = [];
    if (book.previewLink != null && book.previewLink.isNotEmpty) {
      widgets.add(InkWell(
        onTap: () {
          _launchURL(book.previewLink + "#v=onepage&q&f=true");
        },
        splashColor: appConfig.secondaryColor,
        child: SimpleListTile(
          leading: Icon(Icons.local_library, color: iconColor, size: iconSize),
          title: Text("Vista previa", style: titleStyle),
          subtitle: Text("Toca aquí", style: subtitleStyle),
        ),
      ));
    }

    if (book.authors != null && book.authors.isNotEmpty) {
      String authors = book.authors.join("\n");
      widgets.add(SimpleListTile(
        // people
        // supervised_user_circle
        leading: Icon(Icons.border_color, color: iconColor, size: iconSize),
        title: Text("Autores", style: titleStyle),
        subtitle: Text(authors, style: subtitleStyle),
      ));
    }

    if (book.publisher != null && book.publisher.isNotEmpty) {
      String publicationInfo = book.publisher + "\n";
      if (book.publishedDate != null) {
        publicationInfo +=
            "Fecha de publicación: " + dateFormat.format(book.publishedDate);
      }

      widgets.add(SimpleListTile(
        leading: Icon(Icons.account_balance, color: iconColor, size: iconSize),
        title: Text("Editor", style: titleStyle),
        subtitle: Text(publicationInfo, style: subtitleStyle),
      ));
    }

    if ((book.isbn10 != null && book.isbn10.isNotEmpty) ||
        (book.isbn13 != null && book.isbn13.isNotEmpty)) {
      String identifiers = "";
      if (book.isbn10 != null && book.isbn10.isNotEmpty) {
        identifiers += "ISBN-10: " + book.isbn10;
      }
      if (book.isbn13 != null && book.isbn13.isNotEmpty) {
        identifiers += "\nISBN-13: " + book.isbn13;
      }
      // outlined_flag
      // info
      widgets.add(SimpleListTile(
        leading: Icon(Icons.info, color: iconColor, size: iconSize),
        title: Text("Identificador", style: titleStyle),
        subtitle: Text(identifiers, style: subtitleStyle),
      ));
    }

    return widgets;
  }

  List<Widget> _getBookDescriptionWidgets(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    List<Widget> widgets = [];
    Widget descriptionTextWidget = _getDescriptionTextWidget();

    widgets.add(Text(
      "Acerca de este libro",
      textAlign: TextAlign.left,
      style: themeData.textTheme.title,
    ));

    widgets.add(SizedBox(height: 24.0));

    if (descriptionTextWidget != null) {
      widgets.add(descriptionTextWidget);
      widgets.add(
        Divider(
          height: 30.0,
          color: Colors.grey,
        ),
      );
    }

    widgets.addAll(_getMoreInfoWidgets(context));

    return widgets.where((widget) => widget != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _getAppbar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getBookDescriptionWidgets(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
