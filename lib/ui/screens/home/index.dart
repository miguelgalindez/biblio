import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblio/ui/screens/home/_body.dart';
import 'package:biblio/ui/screens/home/_exitConfirmation.dart';
import 'package:biblio/ui/screens/home/_navigationBar.dart';
import 'package:biblio/ui/screens/home/_header.dart';
import 'package:biblio/blocs/homeScreenBloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription snackBarsSubscription;

  @override
  void initState() {
    homeScreenBloc.init();
    snackBarsSubscription =
        homeScreenBloc.snackBars.listen(_snackBarsListener);
    super.initState();
  }

  @override
  void dispose() {
    snackBarsSubscription.cancel();
    homeScreenBloc.dispose();
    super.dispose();
  }

  Future<void> _snackBarsListener(SnackBar snackBar) async {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print("[Home/index] Building widget...");
    Color primaryColor = Theme.of(context).primaryColor;
    return WillPopScope(
      child: Scaffold(
        appBar: Header(screenBloc: homeScreenBloc, primaryColor: primaryColor),
        bottomNavigationBar: NavigationBar(screenBloc: homeScreenBloc, primaryColor: primaryColor),
        body: Body(screenBloc: homeScreenBloc, primaryColor: primaryColor),
        key: _scaffoldKey,
      ),
      onWillPop: () => _showExitConfirmation(context),
    );
  }
}

Future<bool> _showExitConfirmation(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (BuildContext context) => ExitConfirmation(),
      ) ??
      false;
}