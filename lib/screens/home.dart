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
import 'package:biblio/ui/screens/inventory/index.dart';

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
      // TODO: put current screen title
      title: Text("Inventario"),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            }),
      ],
    );
  }

  Widget _selectPage(AppVariables appVariables, Color primaryColor, bool invertColours) {
    Widget page;
    switch (_selectedPageIndex) {
      case 0:
        page = BookScanScreen(autoScan: false);
        break;
      case 1:
        page = SearchBookScreen(bookCategories: appVariables.categories);
        break;
      case 4:
        page = Inventory();
        break;
      default:
        page = UnderConstruction();
        break;
    }

    return Container(
      color: invertColours ? primaryColor : null,
      child: page,
    );
  }

  Widget _buildBottomNavigationBar(Color primaryColor, bool invertColours) {
    return CurvedNavigationBar(
      index: _selectedPageIndex,
      onTap: (int index) {
        setState(() {
          _selectedPageIndex = index;
        });
      },
      items: <Widget>[
        Icon(MdiIcons.barcodeScan,
            size: 30, color: invertColours ? primaryColor : Colors.white),
        Icon(Icons.search,
            size: 30, color: invertColours ? primaryColor : Colors.white),
        Icon(Icons.local_library,
            size: 30, color: invertColours ? primaryColor : Colors.white),
        Icon(Icons.monetization_on,
            size: 30, color: invertColours ? primaryColor : Colors.white),
        Icon(Icons.settings,
            size: 30, color: invertColours ? primaryColor : Colors.white),
      ],
      backgroundColor: invertColours ? primaryColor : Colors.white,
      buttonBackgroundColor: invertColours ? Colors.white : primaryColor,
      color: invertColours ? Colors.white : primaryColor,
      height: 50.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppConfig appConfig = AppConfig.of(context);
    bool invertColours = _selectedPageIndex == 0 || _selectedPageIndex == 4;
    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppbar(context, appConfig),
        bottomNavigationBar: _buildBottomNavigationBar(appConfig.primaryColor, invertColours),
        body: ScopedModelDescendant<AppVariables>(
          builder: (context, child, appVariables) => _selectPage(appVariables, appConfig.primaryColor, invertColours),
          rebuildOnChange: true,
        ),
      ),
      onWillPop: () => _onWillPop(context),
    );
  }
}
