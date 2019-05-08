import 'package:flutter/material.dart';
import 'package:biblio/screens/login.dart';
import 'package:biblio/models/appConfig.dart';

ThemeData buildTheme(AppConfig appConfig) {
  final ThemeData base = ThemeData();

  return base.copyWith(
      hintColor: Colors.white70,
      primaryColor: appConfig.primaryColor,      
      primaryIconTheme: base.primaryIconTheme.copyWith(color: Colors.white));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner:
          appConfig.projectStage == ProjectStages.development,
      title: appConfig.appName,
      theme: buildTheme(appConfig),
      home: LoginScreen(),
    );
  }
}
