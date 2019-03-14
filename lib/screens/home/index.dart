import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/screens/home/bookSearchDelegate.dart';
import 'package:biblio/screens/home/body.dart';
import 'package:biblio/services/categories-mock-data.dart';
import 'package:biblio/models/category.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);

    Future<bool> _onWillPop() async {
      return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: Text('¿Desea salir de la aplicación?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text('Si'),
                    ),
                  ],
                ),
          ) ??
          false;
    }

    AppBar appBar = AppBar(
      backgroundColor: appConfig.primaryColor,
      title: Text(appConfig.appName),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            }),
      ],
    );

    return WillPopScope(
      child: Scaffold(
        appBar: appBar,
        drawer: Drawer(),
        body: FutureBuilder(
          future: getCategories(context),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return HomeBody(
                bookCategories: snapshot.data,
              );
            }
            return Text("Loading...");
          },
        ),
      ),
      onWillPop: _onWillPop,
    );
  }
}
