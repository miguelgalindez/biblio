import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/hero_photo_viewer.dart';
import 'package:biblio/components/book/bookThumbnail.dart';
import 'package:biblio/screens/details/bookStats.dart';

class BookDetails extends StatelessWidget {
  final Book book;

  BookDetails({Key key, @required this.book}) : super(key: key);

  _thumbnailWithPhotoView(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HeroPhotoViewWrapper(
                    heroTag: book.getId(),
                    imageProvider: NetworkImage(book.thumbnail),
                  ),
            ),
          );
        },
        child: Container(
          child: BookThumbnail(
            thumbnailUrl: book.smallThumbnail,
            heroTag: book.getId(),
          ),
        ),
      ),
    );
  }

  Widget _getAppBar() {
    return SliverAppBar(
      // TODO make this a dynamic value (Global state)
      expandedHeight: 56.0,
      pinned: false,
      floating: false,
      snap: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Buscar libro',
          onPressed: () {
            print("[details/index] Book search button tapped");
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: "Más",
          onPressed: () {
            print("[details/index] More options button tapped");
          },
        ),
      ],
    );
  }

  Widget _getBookTitleText(ThemeData themeData) {
    String title = book.title;
    if (title != null && title.isNotEmpty) {
      return Text(
        book.title,
        style: themeData.textTheme.title.copyWith(fontWeight: FontWeight.bold),
      );
    }
    return null;
  }

  Widget _getBookAuthorsText(ThemeData themeData) {
    String authors = book.getInlineAuthors();
    if (authors != null) {
      return Padding(
        padding: EdgeInsets.only(top: 7.0),
        child: Text(
          authors,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              themeData.textTheme.body1.copyWith(color: themeData.primaryColor),
        ),
      );
    }
    return null;
  }

  Widget _getBookPublisherText(ThemeData themeData) {
    String publisher = book.publisher;
    if (publisher != null && publisher.isNotEmpty) {
      return Text(
        book.publisher,
        style: themeData.textTheme.caption.copyWith(color: Colors.grey),
      );
    }
    return null;
  }

  Widget _getReserveBookButton(ThemeData themeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          elevation: 0.0,
          color: themeData.primaryColor,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text("Reservar"),
          onPressed: () {
            print("[details-index] Reserve book button tapped");
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _getAppBar(),
          SliverToBoxAdapter(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: _thumbnailWithPhotoView(context),
                                title: _getBookTitleText(themeData),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _getBookAuthorsText(themeData),
                                    _getBookPublisherText(themeData),
                                  ].where((widget) => widget != null).toList(),
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _getReserveBookButton(themeData),
                                    Divider(height: 20.0),
                                    BookStats(book: book),
                                    Divider(height: 20.0),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
