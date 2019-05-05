import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:biblio/models/book.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:biblio/models/appVariables.dart';
import 'package:biblio/components/book/cardBook.dart';
import 'package:animator/animator.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class BookScan extends StatefulWidget {
  @override
  _BookScanState createState() => _BookScanState();
}

class _BookScanState extends State<BookScan> {
  bool showBook;

  @override
  void initState() {
    showBook = false;
    super.initState();
  }

  Widget _buildWidget(BuildContext context) {
    if (showBook) {
      Book book = ScopedModel.of<AppVariables>(context).books[4];
      return Animator(
        duration: Duration(seconds: 1),
        curve: Curves.bounceInOut,
        tween: Tween(begin: 0.01, end: 1.0),
        builder: (Animation animation) => Transform.scale(
              scale: animation.value,
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: CardBook(
                    book: book,
                    size: CardBookSize.big,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showBook = false;
                  });
                },
              ),
            ),
      );
    } else {
      return GestureDetector(
        child: FadeInImage(
          image: AssetImage("assets/logo-nfc.png"),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          height: 250.0,
          width: 250.0,
          placeholder: AssetImage('assets/x.jpg'),
        ),
        onTap: () {
          sleep(const Duration(seconds: 1));
          setState(() {
            showBook = true;
          });
        },
      );
    }
  }

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
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text("Scan"),
          onPressed: _scanQR,
        ),
      ),
    );
  }
}
