import 'dart:math';
import 'package:biblio/models/review.dart';
import 'package:biblio/models/User.dart';

Random random = new Random();
int topPositiveReviewIndex;
int topNegativeReviewIndex;

List<User> mockUsers = [
  User(
    id: 1,
    name: "Maria Córdoba",
    username: "maria",
    photo: "assets/avatar-1.png",
  ),
  User(
    id: 2,
    name: "Camilo Cifuentes",
    username: "pepito",
    photo: "assets/avatar-2.png",
  ),
  User(
    id: 3,
    name: "Laura Contreras",
    username: "laura",
    photo: "assets/avatar-3.png",
  ),
  User(
    id: 4,
    name: "Steve",
    username: "steve",
    photo: "assets/avatar-4.png",
  ),
];

List<String> mockComments = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. ",
  "Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. ",
  "Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. ",
];

List<Review> mockReviews = [
  Review(
      id: "1",
      comment: mockComments[0],
      date: DateTime(2015, 05, 12),
      rating: 4.0,
      user: mockUsers[0]),
  Review(
      id: "2",
      comment: mockComments[1],
      date: DateTime(2017, 11, 06),
      rating: 3.5,
      user: mockUsers[1]),
  Review(
      id: "3",
      comment: mockComments[2],
      date: DateTime(2013, 02, 27),
      rating: 5,
      user: mockUsers[2]),
  Review(
      id: "4",
      comment: mockComments[3],
      date: DateTime(2019, 01, 12),
      rating: 1,
      user: mockUsers[3]),
];

List<Review> getAllReviews() {
  return mockReviews;
}

Review getTopPositiveReview() {
  topPositiveReviewIndex = random.nextInt(4);
  return Review(
    id: topPositiveReviewIndex.toString(),
    user: mockUsers[topPositiveReviewIndex],
    comment: mockComments[topPositiveReviewIndex],
    date: DateTime(2010 + topPositiveReviewIndex, 1 + topPositiveReviewIndex, 18 + topPositiveReviewIndex),
    rating: 3.0 + random.nextInt(3).toDouble(),
  );
}

Review getTopNegativeReview() {
  do{
  topNegativeReviewIndex  = random.nextInt(4);    
  } while(topPositiveReviewIndex==topNegativeReviewIndex);

  return Review(
    id: topNegativeReviewIndex.toString(),
    user: mockUsers[topNegativeReviewIndex],
    comment: mockComments[topNegativeReviewIndex],
    date: DateTime(2010 + topNegativeReviewIndex, 1 + topNegativeReviewIndex, 18 + topNegativeReviewIndex),
    rating: random.nextInt(3).toDouble(),
  );
}

Review getReview() {
  int number = random.nextInt(4);
  return Review(
    id: number.toString(),
    user: mockUsers[number],
    comment: mockComments[number],
    date: DateTime(2010 + number, 1 + number, 18 + number),
    rating: 3.0 + random.nextInt(3).toDouble(),
  );
}
