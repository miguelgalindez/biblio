import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String path = '';

class User {
  int id;
  String username;
  String name;
  bool isAuthenticated;

  User({this.id, this.username, this.name, this.isAuthenticated});

  factory User.fromJson(Map<String, dynamic> json) {
    var isAuthenticated = json['isAuthenticated'];    
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      isAuthenticated:
          isAuthenticated is bool ? isAuthenticated : isAuthenticated == 1,
    );
  }

  static Future<User> signIn(String username, String password) async {
    final response = await http.post('http://192.168.1.124:9308/users/auth',
        body: {'username': username, 'password': password});
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      return User.fromJson(result);
    } else {
      /*
        TODO check for the common status code for responses.
              Check waht happens when there's no internet connection
              or the server is down
        TODO how to properly debug messages
       */
      print("Error: " + result.error);
      return null;
    }
  }
}
