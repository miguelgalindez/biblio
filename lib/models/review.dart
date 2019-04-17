import 'package:biblio/models/User.dart';
import './sortingCriteria.dart';

class Review {
  String id;
  User user;
  double rating;
  String comment;
  DateTime date;
  static List<SortingCriteria> sortingCriterias = _loadSortingCriterias();

  Review({this.id, this.user, this.rating, this.comment, this.date});

  static List<SortingCriteria> _loadSortingCriterias() {
    return [
      SortingCriteria(id: "mostRecent", description: "Más reciente"),
      SortingCriteria(id: "oldest", description: "Más antigua"),
      SortingCriteria(id: "highest", description: "Más alta"),
      SortingCriteria(id: "lowest", description: "Más baja"),
    ];
  }
}
