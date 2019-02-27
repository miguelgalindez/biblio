import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/models/User.dart';

final String authURI = 'users/auth';

class UserServices {
  static Future<User> signIn(String username, String password, BuildContext context) async {
    var appConfig = AppConfig.of(context);

    final response = await http.post(
      appConfig.apiBaseUrl + authURI,
      body: {'username': username, 'password': password},
    );

    var responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      User user = User.fromJson(responseBody);
      if (user.isAuthenticated) {
        return user;
      } else {
        throw "Usuario o contraseña inválidos";
      }
    } else {
      print("Error: " + responseBody.error);
      throw ("Error al intentar conectar con el servidor");
    }
  }
}
