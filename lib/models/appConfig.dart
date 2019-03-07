import 'package:flutter/material.dart';

class ProjectStages {
  static const development = "dev";
  static const production = "prod";
}

class AppConfig extends InheritedWidget {
  final String appName;
  final String projectStage;
  final String apiBaseUrl;  
  final Color primaryColor;
  final Color secondaryColor;

  AppConfig({
    @required this.appName,
    @required this.projectStage,
    @required this.apiBaseUrl,
    @required this.primaryColor,
    @required this.secondaryColor,
    @required Widget child,
  }) : super(child: child);

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
