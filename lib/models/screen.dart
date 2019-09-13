import 'package:biblio/models/deviceCapabilities.dart';
import 'package:flutter/widgets.dart';

/**
 * Model for the home screens. 
 */

enum ScreenId { CODE_SCAN, BOOK_CATALOG, INVENTORY }

class Screen {
  ScreenId id;
  int priority;
  int index;
  String title;
  Widget body;
  IconData icon;
  bool invertColors;

  Screen({this.id, this.priority, this.title, this.body});

  factory Screen.fromJSON(Map<dynamic, String> json) {
    return Screen(
      id: _getIdFromString(json['id']),
      priority: int.tryParse(json['priority']),
      title: json['title'],
    );
  }

  bool isSupported(DeviceCapabilities deviceCapabilities) {
    switch (id) {
      case ScreenId.INVENTORY:
        return deviceCapabilities.rfidTagsReading;
        break;
      case ScreenId.CODE_SCAN:
        return deviceCapabilities.camera;
      default:
        return true;
    }
  }

  static ScreenId _getIdFromString(String id){
    switch (id) {
      case "codeScan":
        return ScreenId.CODE_SCAN;

      case "bookCatalog":
        return ScreenId.BOOK_CATALOG;

      case "inventory":
        return ScreenId.INVENTORY;

      default:
        return null;
    }
  }
}
