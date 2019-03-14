import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:biblio/components/hero_photo_viewer.dart';
import 'package:biblio/components/book/bookThumbnail.dart';

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
                      )));
        },
        child: Container(
          child: BookThumbnail(
            thumbnailUrl: book.thumbnail,
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

  TextStyle _getBookTitleTextStyle(ThemeData themeData) {
    return themeData.textTheme.title.copyWith(fontWeight: FontWeight.bold);
  }

  TextStyle _getBookAuthorsTextStyle(ThemeData themeData) {
    return themeData.textTheme.body1.copyWith(color: themeData.primaryColor);
  }

  TextStyle _getBookPublisherTextStyle(ThemeData themeData) {
    return themeData.textTheme.caption.copyWith(color: Colors.grey);
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
                                title: Text(
                                  book.title,
                                  style: _getBookTitleTextStyle(themeData),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      // TODO: fix this !!
                                      child: Text(
                                        "Authors....",
                                        style:
                                            _getBookAuthorsTextStyle(themeData),
                                      ),
                                    ),
                                    Text(
                                      book.publisher ?? '',
                                      style:
                                          _getBookPublisherTextStyle(themeData),
                                    ),
                                  ].where((widget) => widget != null).toList(),
                                ),
                              ),
                              // TODO: fix this !!
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            RaisedButton(
                                              elevation: 0.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30.0),
                                              child: Text("Reservar"),
                                              onPressed: () {
                                                print(
                                                    "[details-index] Reserve book button tapped");
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    )
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
