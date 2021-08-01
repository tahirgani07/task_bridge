class MyUser {
  final String name;
  final String photoUrl;
  final String state;
  final String city;
  final double rating;
  final int workDone;
  List tags;

  MyUser({
    required this.name,
    required this.photoUrl,
    required this.state,
    required this.city,
    required this.rating,
    required this.workDone,
    required this.tags,
  });
}
