import 'package:flutter/material.dart';
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/app.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';

void main() {
  runApp(ConfiguredApp());
}

class ConfiguredApp extends StatelessWidget {
  final AppVariables appVariables = AppVariables();

  @override
  Widget build(BuildContext context) {
    return AppConfig(
      appName: 'Sigma Mobile',
      projectStage: ProjectStages.development,
      apiBaseUrl: "http://192.168.1.124:9308/",
      //primaryColor: Color(0xff4285F4),
      //primaryColor: Color(0xff01305c),
      primaryColor: Colors.blue[900],
      secondaryColor: Colors.red[700],
      //secondaryColor: Color(0xffA41617),

      child: ScopedModel<AppVariables>(
        model: appVariables,
        child: App(),
      ),
    );
  }
}
