import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BookScanScreen extends StatelessWidget {
  // If true, the device will start to scan as soon
  // as this widget is built
  final bool autoScan;

  BookScanScreen({this.autoScan = false});

  Future<void> _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print("QR result: " + qrResult);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print("The user did not grant the camera permission!");
      } else {
        print("Unknown error: $e");
      }
    } on FormatException {
      print(
          "null (User returned using the back-button before scanning anything. Result)");
    } catch (e) {
      print("Unknown error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    TextStyle textStyle=themeData.textTheme.subhead.copyWith(
      color: Colors.white,
    );

    if (autoScan) {
      _scanQR();
    }
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MdiIcons.barcodeScan, size: 60.0, color: Colors.white),
                SizedBox(width: 40.0),
                Icon(MdiIcons.qrcodeScan, size: 60.0, color: Colors.white),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "Toma el libro que deseas y escanea su código de barras o QR usando el siguiente botón:",
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
            RaisedButton(
              color: Colors.white,
              child: Text("ESCANEAR CÓDIGO DE BARRAS O QR", style: TextStyle(color: themeData.primaryColor, fontWeight: FontWeight.bold)),
              onPressed: _scanQR,
            ),
          ]),
    );
  }
}
