import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  // Making this class a singleton.
  static final Database _database = Database._init();
  Database._init() {
    print("Database Initialised.");
  }

  factory Database() {
    return _database;
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future addUserToCollectionIfNew(String uid) async {
    DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();
    if (!snapshot.exists) {
      print("New User!");
      await db.collection("users").doc(uid).set({
        "freelancer": false,
      });
      return true;
    }
    return false;
  }

  Future isFreelancer(String uid) async {
    bool result = false;
    DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();
    if (snapshot.exists) result = snapshot.get("freelancer");
    print(result);
    return result;
  }
}
