import 'package:flutter/widgets.dart';

/**
 * Model for the home screens. 
 */

enum ScreenId { CODE_SCAN, BOOK_CATALOG, INVENTORY }

class Screen {
  ScreenId id;
  int index;
  String title;
  Widget body;
  IconData icon;
  bool invertColors;

  Screen({this.id, this.index, this.title, this.body});

  factory Screen.fromJSON(Map<dynamic, String> json) {
    return Screen(
      id: _getIdFromString(json['id']),
      index: int.tryParse(json['index']),
      title: json['title'],
    );
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
