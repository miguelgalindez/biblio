import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  MethodChannel rfidReaderChannel;

  @override
  void initState() {
    rfidReaderChannel = MethodChannel("biblio/rfidReader/methodChannel");
    rfidReaderChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onTagRead":
          print("Number of tags; ${call.arguments.length}");
          List<dynamic> data = call.arguments;
          print("Number of casted tags; ${data.length}");
          List<Map<dynamic, dynamic>> tags=data.cast<Map<dynamic, dynamic>>().map((item)=> item.cast<String, String>()).toList();
          
          tags.forEach((tag) {

            print("epc: ${tag["epc"]}");
            print("pc: ${tag["pc"]}");
            print("tid: ${tag["tid"]}");
            print("rssi: ${tag["rssi"]}");
            print("-----");
          });
        
          //print("Android result ${call.arguments}");
          break;
        default:
          throw MissingPluginException();
      }
    });

    super.initState();
  }

  Future<void> startInventory() async {
    try {
      String result = await rfidReaderChannel.invokeMethod("startInventory");
      print("Flutter start inventory: $result");
    } catch (e) {
      print("Flutter start inventory exception: ${e.message}");
    }
  }

  Future<void> stopInventory() async {
    try {
      String result = await rfidReaderChannel.invokeMethod("stopInventory");
      print("Flutter stop inventory: $result");
    } catch (e) {
      print("Flutter stop inventory exception: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Start inventory"),
              onPressed: startInventory,
            ),
            RaisedButton(
              child: Text("Stop inventory"),
              onPressed: stopInventory,
            ),
          ],
        ),
      ),
    );
  }
}
