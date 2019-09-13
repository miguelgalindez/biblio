import 'package:biblio/models/screen.dart';

class MockApi {
  static Future<List<Screen>> getAvailableScreens() async {
    return [
      Screen(id: ScreenId.CODE_SCAN, priority: 0, title: "Escanear código"),
      Screen(id: ScreenId.BOOK_CATALOG, priority: 1, title: "Catálogo"),
      Screen(id: ScreenId.INVENTORY, priority: 4, title: "Inventario"),
    ];
  }
}
