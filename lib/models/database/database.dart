import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_bridge/models/quiz_model/quiz_model.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';

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
        "uid": user.uid,
        "name": name != null ? name : user.displayName,
        "photoUrl": photoUrl != null ? photoUrl : user.photoURL,
        "email": user.email,
        "state": "",
        "city": "",
        "tags": [],
        "rating": 0,
        "workDone": 0,
        "quizTaken": false,
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
    required String email,
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
      "quizTaken": false,
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
        "email": email,
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
    Timestamp timestamp = Timestamp.now();
    await db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("chats")
        .doc(timestamp.millisecondsSinceEpoch.toString())
        .set({
      "uid": senderUid,
      "message": message,
      "read": false,
      "timestamp": timestamp,
    });
  }

  Future<bool> checkIfUserIsAddedToMsgList({
    required String uid1,
    required String name1,
    required String email1,
    required String photoUrl1,
    required String uid2,
    required String name2,
    required String email2,
    required String photoUrl2,
  }) async {
    bool success = true;
    try {
      // Checking if user2 exists in user1
      DocumentSnapshot snap1 = await db
          .collection("users")
          .doc(uid1)
          .collection("chats")
          .doc(uid2)
          .get();

      String combinedUid = UserModel.getCombinedUid(uid1, uid2);
      if (!snap1.exists) {
        await db.collection("all-chats").doc(combinedUid).set({
          "combinedUid": combinedUid,
        });
      }

      if (!snap1.exists) {
        await db
            .collection("users")
            .doc(uid1)
            .collection("chats")
            .doc(uid2)
            .set({
          "uid": uid2,
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
        });
      }
    } catch (e) {
      print(e.toString());
      success = false;
    }
    return success;
  }

  Future updatePhotoUrl(
      String uid, String url, String? state, String? city) async {
    bool success = true;
    await db.collection("users").doc(uid).update({
      "photoUrl": url,
    }).onError((error, stackTrace) => success = false);

    if (success)
      await db.collection("users").doc(uid).update({
        "photoUrl": url,
      }).onError((error, stackTrace) => success = false);

    if (success && UserModel.isFreelancer) {
      DocumentSnapshot docSnap = await db.collection("users").doc(uid).get();
      String state = docSnap["state"];
      String city = docSnap["city"];
      await db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .collection("freelancers")
          .doc(uid)
          .update({
        "photoUrl": url,
      }).onError((error, stackTrace) => success = false);
    }

    return success;
  }

  Future updateDisplayName(User user, String newName) async {
    bool success = true;
    await user.updateDisplayName(newName).onError((error, stackTrace) {
      success = false;
    });
    if (success)
      await db.collection("users").doc(user.uid).update({
        "name": newName,
      }).onError((error, stackTrace) => success = false);

    if (success && UserModel.isFreelancer) {
      DocumentSnapshot docSnap =
          await db.collection("users").doc(user.uid).get();
      String state = docSnap["state"];
      String city = docSnap["city"];
      await db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .collection("freelancers")
          .doc(user.uid)
          .update({
        "name": newName,
      }).onError((error, stackTrace) => success = false);
    }

    return success;
  }

  Future<bool> bookmarkUser({
    required String userUid,
    required String bookmarkUserUid,
  }) async {
    bool success = true;
    await db
        .collection("users")
        .doc(userUid)
        .collection("bookmarks")
        .doc(bookmarkUserUid)
        .set({
      "uid": bookmarkUserUid,
    }).onError((error, stackTrace) => success = false);
    return success;
  }

  Future<bool> deleteBookmark({
    required String userUid,
    required String bookmarkUserUid,
  }) async {
    bool success = true;
    await db
        .collection("users")
        .doc(userUid)
        .collection("bookmarks")
        .doc(bookmarkUserUid)
        .delete()
        .onError((error, stackTrace) => success = false);
    return success;
  }

  Future<List<Question>> getRandomQuesions({
    required List<String> tags,
    required String language,
    required int noOfQuestions,
  }) async {
    List<Question> res = [];
    List<Question> allQs = [];

    for (int i = 0; i < tags.length; i++) {
      String tag = tags[i];
      QuerySnapshot snap = await db
          .collection("tags")
          .doc(tag)
          .collection("quiz-$language")
          .get();
      allQs.addAll(snap.docs.map((q) {
        return Question(
          question: q["question"],
          op1: q["op1"],
          op2: q["op2"],
          op3: q["op3"],
          op4: q["op4"],
          answer: q["answer"],
        );
      }).toList());
    }

    if (allQs.length <= 0) return [];
    List<int> generatedNos = [];
    int range = allQs.length;
    for (int i = 0; i < noOfQuestions; i++) {
      int randomNo;
      do {
        randomNo = Random().nextInt(range);
      } while (generatedNos.contains(randomNo));
      generatedNos.add(randomNo);
      res.add(allQs[randomNo]);
    }
    return res;
  }

  Future<bool> updateRating(String uid, double curRating,
      {bool incrementWorkDone: false}) async {
    bool success = true;
    MyUser user = await UserModel.getParticularUserDetails(uid);
    double newRating =
        double.parse(((user.rating + curRating) / 2).toStringAsFixed(2));
    if (user.rating == 0) {
      newRating = curRating;
    }
    int workDone = incrementWorkDone ? user.workDone + 1 : user.workDone;
    await db.collection("users").doc(uid).update({
      "quizTaken": true,
      "rating": newRating,
      "workDone": workDone,
    }).onError((error, stackTrace) => success = false);

    if (success)
      await db
          .collection("states")
          .doc(user.state)
          .collection("city")
          .doc(user.city)
          .collection("freelancers")
          .doc(uid)
          .update({
        "rating": newRating,
        "workDone": workDone,
      }).onError((error, stackTrace) => success = false);

    return success;
  }
}
