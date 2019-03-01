import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/models/User.dart';

final String authURI = 'users/auth';

/*
  TODO: Implement the better way to log messages
*/

class UserServices {
  static Future<User> signIn(
      String username, String password, AppConfig appConfig) async {
    final String url = appConfig.apiBaseUrl + authURI;
    final response = await http.post(
      url,
      body: {'username': username, 'password': password},
    );

    var responseBody = json.decode(response.body);
    switch (response.statusCode) {
      // OK
      case 200:
        User user = User.fromJson(responseBody);
        if (user.isAuthenticated) {
          return user;
        } else {
          throw "Usuario o contraseña inválidos";
        }
        break;
      // BAD REQUEST
      case 400:
        throw (responseBody["error"]);
        break;

      // UNKNOWN ERROR - Show generic message to user and log the specific error.
      default:
        print("Error: " + responseBody["error"]);
        throw "Error al intentar conectar con el servidor";
        break;
    }
  }
}
