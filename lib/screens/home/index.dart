import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/screens/home/bookSearchDelegate.dart';
import 'package:biblio/screens/home/body.dart';
import 'package:biblio/services/categories-mock-data.dart';
import 'package:biblio/models/category.dart';
import 'package:biblio/components/modalProgressIndicator.dart';

class Home extends StatelessWidget {
  Future<bool> _onWillPop(BuildContext context) async {
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

  Widget _buildAppbar(BuildContext context){
    AppConfig appConfig = AppConfig.of(context);
    
    return AppBar(
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppbar(context),
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
            return ModalProgressIndicator();
          },
        ),
      ),
      onWillPop: () => _onWillPop(context),
    );
  }
}
