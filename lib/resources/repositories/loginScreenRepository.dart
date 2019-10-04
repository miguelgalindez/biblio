import 'package:biblio/models/ApiResponse.dart';
import 'package:biblio/models/User.dart';
import 'package:biblio/resources/api/mockApi.dart';

class LoginScreenRepository {
  /// TODO: update this when create the rest api (follow the platform api)
  static Future<void> signIn(String username, String password,
      Function onSuccess, Function onError) async {
    ApiResponse response = await MockApi.signIn(username, password);
    if (!response.hasError) {
      User user = response.content;
      if (user.isAuthenticated) {
        onSuccess(response.content);
      } else {
        onError('Usuario o contraseña incorrectos');
      }
    } else {
      onError(response.content);
    }
  }
}
