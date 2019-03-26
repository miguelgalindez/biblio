import 'package:biblio/models/User.dart';

class Review {
  String id;
  User user;
  double rating;
  String comment;
  DateTime date;

  Review({this.id, this.user, this.rating, this.comment, this.date});
  
}
