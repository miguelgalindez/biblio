import 'package:biblio/blocs/deviceUtilititesBloc.dart';
import 'package:flutter/material.dart';
import 'package:biblio/ui/screens/login/index.dart';
import 'package:biblio/models/appConfig.dart';

ThemeData buildTheme(BuildContext context, AppConfig appConfig) {
  final ThemeData base = Theme.of(context);

  return base.copyWith(
    //hintColor: Colors.white70,
    primaryColor: appConfig.primaryColor,
    primaryIconTheme: base.primaryIconTheme.copyWith(color: Colors.white),
    textTheme: base.textTheme.apply(fontFamily: 'Montserrat'),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {    
    super.initState();
    deviceUtilitiesBloc.init();
  }

  @override
  void dispose() {
    deviceUtilitiesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner:
          appConfig.projectStage == ProjectStages.development,
      title: appConfig.appName,
      theme: buildTheme(context, appConfig),
      home: LoginScreen(),
    );
  }
}
