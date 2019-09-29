import 'package:flutter/material.dart';
import 'package:biblio/ui/screens/blocEvent.dart';
import 'package:biblio/blocs/homeScreenBloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationBar extends StatelessWidget {
  final HomeScreenBloc screenBloc;
  final Color primaryColor;
  NavigationBar({@required this.screenBloc, @required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/BottomNavigationBar] Building widget...");
    return StreamBuilder(
      stream: screenBloc.currentScreenAndAvailableScreens,
      builder: (BuildContext context,
          AsyncSnapshot<CurrentScreenAndAvailableScreens> snapshot) {
        if (snapshot.hasData) {
          return CurvedNavigationBar(
            index: snapshot.data.currentScreen.index,
            onTap: (int index) {
              screenBloc.eventsSink.add(BlocEvent(
                action: HomeScreenActions.SWITCH_TO_SCREEN,
                data: index,
              ));
            },
            items: snapshot.data.availableScreens
                .map((screen) => Icon(
                      screen.icon,
                      size: 30,
                      color: snapshot.data.currentScreen.invertColors
                          ? primaryColor
                          : Colors.white,
                    ))
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
