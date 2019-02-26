import 'package:flutter/material.dart';
import 'package:biblio/screens/login/index.dart';
import 'package:biblio/models/appConfig.dart';

ThemeData buildTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(hintColor: Colors.white70);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner:
          config.projectStage == ProjectStages.development,
      title: config.appName,
      theme: buildTheme(),
      home: LoginScreen(),
    );
  }
}
