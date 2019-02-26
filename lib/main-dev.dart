import 'package:flutter/material.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/app.dart';

void main() {
  runApp(ConfiguredApp());
}

class ConfiguredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppConfig(
      appName: 'Biblio Dev',
      projectStage: ProjectStages.development,
      apiBaseUrl: "http://192.168.52.21:9308/",
      child: App(),
    );
  }
}
