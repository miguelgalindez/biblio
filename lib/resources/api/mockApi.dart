import 'package:biblio/models/ApiResponse.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/models/screen.dart';

const allowedUsers=[
  'miguelgalindez',
  'wriascos'
];

class MockApi {
  static Future<List<Screen>> getAvailableScreens() async {
    return [
      Screen(id: ScreenId.CODE_SCAN, priority: 0, title: "Escanear código"),
      Screen(id: ScreenId.BOOK_CATALOG, priority: 1, title: "Catálogo"),
      Screen(id: ScreenId.INVENTORY, priority: 4, title: "Inventario"),
    ];
  }

  /// TODO: use config file for company id and  backend's api, and so on.
  static Future<ApiResponse> signIn(String username, String password) async {
    if(username!=null && allowedUsers.contains(username)){
      return ApiResponse(hasError: false, statusCode: 200, content: User(id: 1, username: username, isAuthenticated: true, name: username));
    } else {
      return ApiResponse(hasError: false, statusCode: 200, content: User(id: 1, username: username, isAuthenticated: false, name: username));
    }
  }
}
