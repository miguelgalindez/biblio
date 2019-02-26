import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biblio/models/appConfig.dart';
import 'package:biblio/models/User.dart';

final String authURI = 'users/auth';

class UserServices {
  static Future<User> signIn(
      String username, String password, BuildContext context) async {
    var appConfig = AppConfig.of(context);
    final response = await http.post(
      appConfig.apiBaseUrl + authURI,
      body: {'username': username, 'password': password},
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(responseBody);
    } else {
      /*
        TODO check for the common status code for responses.
              Check waht happens when there's no internet connection
              or the server is down
        TODO how to properly debug messages
       */
      print("Error: " + responseBody.error);
      return null;
    }
  }
}
