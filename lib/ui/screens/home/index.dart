import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/ui/screens/home/homeScreenBloc.dart';
import 'package:biblio/components/book/bookSearchDelegate.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    homeScreenBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    homeScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[Home/index] Building widget...");
    Color primaryColor = Theme.of(context).primaryColor;
    return WillPopScope(
      child: Scaffold(
        appBar: Header(primaryColor: primaryColor),
        bottomNavigationBar: BottomNavigationBar(primaryColor: primaryColor),
        body: Body(primaryColor: primaryColor),
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

class Header extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;
  Header({@required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/Header] Building widget...");
    return AppBar(
      backgroundColor: primaryColor,
      title: StreamBuilder(
        stream: homeScreenBloc.currentScreen,
        builder: (BuildContext context, AsyncSnapshot<Screen> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.title);
          } else if (snapshot.hasError) {
            return const Center(child: const Text("Error"));
          } else {
            return const Center(child: const CircularProgressIndicator());
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

class Body extends StatelessWidget {
  final Color primaryColor;
  Body({@required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/Body] Building widget...");
    return StreamBuilder(
      stream: homeScreenBloc.currentScreen,
      builder: (BuildContext context, AsyncSnapshot<Screen> snapshot) {
        if (snapshot.hasData) {
          Screen screen = snapshot.data;
          return primaryColor != null
              ? Container(
                  color: screen.invertColors ? primaryColor : null,
                  child: screen.body,
                )
              : screen.body;
        } else if (snapshot.hasError) {
          return const Center(
            child: const Text("Error al intentar cargar la pantalla"),
          );
        } else {
          return const Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

class BottomNavigationBar extends StatelessWidget {
  final Color primaryColor;
  BottomNavigationBar({@required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/BottomNavigationBar] Building widget...");
    return StreamBuilder(
      stream: homeScreenBloc.currentScreenAndAvailableScreens,
      builder: (BuildContext context,
          AsyncSnapshot<CurrentScreenAndAvailableScreens> snapshot) {
        if (snapshot.hasData) {
          return CurvedNavigationBar(
            index: snapshot.data.currentScreen.index,
            onTap: (int index) {
              homeScreenBloc.switchToScreen.add(index);
            },
            items: snapshot.data.availableScreens
                .map((screen) => Icon(screen.icon,
                    size: 30,
                    color: snapshot.data.currentScreen.invertColors
                        ? primaryColor
                        : Colors.white))
                .toList(),
            backgroundColor: snapshot.data.currentScreen.invertColors
                ? primaryColor
                : Colors.white,
            buttonBackgroundColor: snapshot.data.currentScreen.invertColors
                ? Colors.white
                : primaryColor,
            color: snapshot.data.currentScreen.invertColors
                ? Colors.white
                : primaryColor,
            height: 50.0,
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: const Text("Error al intentar cargar el menú"),
          );
        } else {
          return const Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}

class ExitConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("[Home/ExitConfirmation] Building widget...");
    return AlertDialog(
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
    );
  }
}
