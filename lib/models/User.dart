class User {
  int id;
  String username;
  String name;
  String photo;
  bool isAuthenticated;

  User({this.id, this.username, this.name, this.isAuthenticated, this.photo});

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
}