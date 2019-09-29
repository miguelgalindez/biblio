import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("[Home/ExitConfirmation] Building widget...");
    return AlertDialog(
      content: const Text('¿Desea salir de la aplicación?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'No',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: const Text(
            'Si',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}