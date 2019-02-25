final userPattern = new RegExp(r"^[a-zA-Z]+[a-zA-Z0-9_-]*$");
final emailPattern = new RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[a-zA-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$");

String validateUsername(String username){
  var isEmail=emailPattern.hasMatch(username);
  var isValidUser=userPattern.hasMatch(username);

  if(isEmail && !username.contains("@unicauca.edu.co") || (!isEmail && !isValidUser)){
    return "Usuario inválido. Debe usar su usuario institucional";
  }
  return null;
}

String validatePassword(String password){
  if(password==null || password.isEmpty){
    return "Ingrese su contraseña";
  }
  return null;
}