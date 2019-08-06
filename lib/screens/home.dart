import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/components/book/bookSearchDelegate.dart';
import 'package:biblio/screens/searchBook/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:biblio/screens/bookScan/index.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:biblio/components/underConstruction.dart';
import 'package:biblio/screens/inventory/index.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
        return BookScanScreen(autoScan: false);
      case 1:
        return SearchBookScreen(bookCategories: appVariables.categories);
      case 4:
        return Inventory();
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
        Icon(MdiIcons.barcodeScan,
            size: 30,
            color: _selectedPageIndex == 0
                ? appConfig.primaryColor
                : Colors.white),
        Icon(Icons.search,
            size: 30,
            color: _selectedPageIndex == 0
                ? appConfig.primaryColor
                : Colors.white),
        Icon(Icons.local_library,
            size: 30,
            color: _selectedPageIndex == 0
                ? appConfig.primaryColor
                : Colors.white),
        Icon(Icons.monetization_on,
            size: 30,
            color: _selectedPageIndex == 0
                ? appConfig.primaryColor
                : Colors.white),
        Icon(Icons.settings,
            size: 30,
            color: _selectedPageIndex == 0
                ? appConfig.primaryColor
                : Colors.white),
      ],
      backgroundColor:
          _selectedPageIndex == 0 ? appConfig.primaryColor : Colors.white,
      buttonBackgroundColor:
          _selectedPageIndex == 0 ? Colors.white : appConfig.primaryColor,
      color: _selectedPageIndex == 0 ? Colors.white : appConfig.primaryColor,
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
