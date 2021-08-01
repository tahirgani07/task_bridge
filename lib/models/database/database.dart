import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_bridge/models/user/my_user.dart';

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

  Future addUserToCollectionIfNew(
    User user, {
    String? name,
    String? photoUrl,
  }) async {
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();
    if (!snapshot.exists) {
      print("New User!");
      await db.collection("users").doc(user.uid).set({
        "freelancer": false,
        "id": user.uid,
        "name": name != null ? name : user.displayName,
        "photoUrl": photoUrl != null ? photoUrl : user.photoURL,
        "email": user.email,
        "state": "",
        "city": "",
        "tags": [],
        "rating": 0,
        "workDone": 0,
      });
      return true;
    }
    return false;
  }

  Future<bool> checkIfFreelancer(String uid) async {
    DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();
    if (snapshot.exists) {
      bool? val = snapshot.get("freelancer");
      return val ?? false;
    }
    return false;
  }

  Future<bool> addAdditionalInfoAndSwitchToFreelancer({
    required String uid,
    required String name,
    required String photoUrl,
    required String state,
    required String city,
    required DateTime dob,
    required String gender,
  }) async {
    bool isSuccess = true;
    await db.collection("users").doc(uid).update({
      "freelancer": true,
      "state": state,
      "city": city,
      "dob": dob,
      "gender": gender,
      "tags": [],
      "rating": 0,
      "workDone": 0,
    }).onError((error, stackTrace) {
      print(error.toString());
      isSuccess = false;
    });
    if (isSuccess) {
      // Add in corresponding state and corresponding city collection.
      DocumentSnapshot stateSnap =
          await db.collection("states").doc(state).get();
      if (!stateSnap.exists) {
        await db.collection("states").doc(state).set({"name": state});
      }
      DocumentSnapshot citySnap = await db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .get();
      if (!citySnap.exists) {
        db
            .collection("states")
            .doc(state)
            .collection("city")
            .doc(city)
            .set({"name": city});
      }
      db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .collection("freelancers")
          .doc(uid)
          .set({
        "uid": uid,
        "photoUrl": photoUrl,
        "name": name,
        "state": state,
        "city": city,
        "tags": [],
        "rating": 0,
        "workDone": 0,
      });
    }
    return isSuccess;
  }

  Future addtags({
    required String uid,
    required List tags,
    required String state,
    required String city,
  }) async {
    bool isSuccess = true;
    await db.collection("users").doc(uid).update({
      "tags": tags,
    }).onError((error, stackTrace) {
      print(error.toString());
      isSuccess = false;
    });
    if (isSuccess) {
      db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .collection("freelancers")
          .doc(uid)
          .update({
        "tags": tags,
      });
    }
    return isSuccess;
  }

  Future sendMessage({
    required String combinedUid,
    required String senderUid,
    required String message,
  }) async {
    await db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("chats")
        .doc(Timestamp.now().millisecondsSinceEpoch.toString())
        .set({
      "uid": senderUid,
      "message": message,
      "timestamp": Timestamp.now(),
    });
  }

  Future checkIfUserIsAddedToMsgList({
    required String uid1,
    required String name1,
    required String email1,
    required String photoUrl1,
    required String uid2,
    required String name2,
    required String email2,
    required String photoUrl2,
  }) async {
    try {
      // Checking if user2 exists in user1
      DocumentSnapshot snap1 = await db
          .collection("users")
          .doc(uid1)
          .collection("chats")
          .doc(uid2)
          .get();

      if (!snap1.exists) {
        await db
            .collection("users")
            .doc(uid1)
            .collection("chats")
            .doc(uid2)
            .set({
          "uid": uid2,
          "photoUrl": photoUrl2,
          "email": email2,
          "name": name2,
        });
      }

      // Checking if user1 exists in user2
      DocumentSnapshot snap2 = await db
          .collection("users")
          .doc(uid2)
          .collection("chats")
          .doc(uid1)
          .get();

      if (!snap2.exists) {
        await db
            .collection("users")
            .doc(uid2)
            .collection("chats")
            .doc(uid1)
            .set({
          "uid": uid1,
          "photoUrl": photoUrl1,
          "email": email1,
          "name": name1,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
