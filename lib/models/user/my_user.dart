class MyUser {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String state;
  final String city;
  final double rating;
  final int workDone;
  final bool quizTaken;
  List tags;

  MyUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.state,
    required this.city,
    required this.rating,
    required this.workDone,
    this.quizTaken: false,
    required this.tags,
  });
}
