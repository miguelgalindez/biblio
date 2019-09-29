import 'package:flutter/material.dart';
import 'package:biblio/models/screen.dart';
import 'package:biblio/blocs/homeScreenBloc.dart';

class Body extends StatelessWidget {
  final HomeScreenBloc screenBloc;
  final Color primaryColor;
  Body({@required this.screenBloc, @required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    print("[Home/Body] Building widget...");
    return StreamBuilder(
      stream: screenBloc.currentScreen,
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
          print("[Home/Body] Error: ${snapshot.error.toString()}");
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
