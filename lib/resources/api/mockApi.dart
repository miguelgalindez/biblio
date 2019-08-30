import 'package:biblio/models/screen.dart';

class MockApi {
  static Future<List<Screen>> getAvailableScreens() async {
    return [
      Screen(id: ScreenId.CODE_SCAN, index: 0, title: "Escanear código"),
      Screen(id: ScreenId.BOOK_CATALOG, index: 1, title: "Catálogo"),
      Screen(id: ScreenId.INVENTORY, index: 2, title: "Inventario"),
    ];
  }
}
