import 'package:flutter/material.dart';
import 'package:biblio/components/book/bookSearchDelegate.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/blocs/homeScreenBloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final HomeScreenBloc screenBloc;
  final Color primaryColor;
  Header({@required this.screenBloc, @required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/Header] Building widget...");
    return AppBar(
      backgroundColor: primaryColor,
      title: StreamBuilder(
        stream: screenBloc.currentScreen,
        builder: (BuildContext context, AsyncSnapshot<Screen> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.title);
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else {
            return const Text("Cargando...");
          }
        },
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            }),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
