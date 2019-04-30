import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/screens/home/bookSearchDelegate.dart';
import 'package:biblio/screens/home/body.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:biblio/screens/bookScan.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:biblio/screens/underConstruction.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex;

  @override
  void initState() {
    _selectedPageIndex = 0;
    super.initState();
  }

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

  Widget _buildAppbar(BuildContext context, AppConfig appConfig) {
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

  Widget _selectPage(AppVariables appVariables) {
    switch (_selectedPageIndex) {
      case 0:
        return HomeBody(bookCategories: appVariables.categories);
      case 1:
        return BookScan();
      default:
        return UnderConstruction();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context, AppConfig appConfig) {
    return CurvedNavigationBar(
      index: _selectedPageIndex,
      onTap: (int index) {
        setState(() {
          _selectedPageIndex = index;
        });
      },
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.local_library, size: 30, color: Colors.white),
        Icon(MdiIcons.barcodeScan, size: 30, color: Colors.white),
        Icon(Icons.monetization_on, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
      ],
      backgroundColor: Colors.white,
      buttonBackgroundColor: appConfig.primaryColor,
      color: appConfig.primaryColor,
      height: 50.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppbar(context, appConfig),
        bottomNavigationBar: _buildBottomNavigationBar(context, appConfig),
        body: ScopedModelDescendant<AppVariables>(
          builder: (context, child, appVariables) => _selectPage(appVariables),
          rebuildOnChange: true,
        ),
      ),
      onWillPop: () => _onWillPop(context),
    );
  }
}
