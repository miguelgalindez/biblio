class UserValidator {
  static final _userPattern = new RegExp(r"^[a-zA-Z]+[a-zA-Z0-9_-]*$");
  static final _emailPattern = new RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[a-zA-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$");

  static String validateUsername(String username) {
    if (username == null || username.isEmpty) {
      return "Ingrese su usuario institucional";
    }

    var isEmail = _emailPattern.hasMatch(username);
    var isValidUser = _userPattern.hasMatch(username);

    if (isEmail && !username.contains("@unicauca.edu.co") ||
        (!isEmail && !isValidUser)) {
      return "Usuario inválido. Debe usar su usuario institucional";
    }

    return null;
  }

  static String validatePassword(String password) {
    if (password == null || password.isEmpty) {
      return "Ingrese su contraseña";
    }
    return null;
  }
}
