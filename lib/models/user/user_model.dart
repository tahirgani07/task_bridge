import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/my_user.dart';

class UserModel {
  static String defaultPhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/task-bridge-f9e1f.appspot.com/o/user%2Fprofile%2Fdefault-avatar.png?alt=media&token=a96179ea-75fa-46e6-9155-90cacea732e0";
  static FirebaseStorage storage = FirebaseStorage.instance;
  // FirebaseStorage(storageBucket: "gs://task-bridge-f9e1f.appspot.com");
  static Future<bool> updateProfilePhoto(
    File file,
    User user,
    String state,
    String city,
  ) async {
    bool success = true;
    var storageRef = storage.ref().child("user/profile/${user.uid}");
    var uploadTask = storageRef.putFile(file);
    String downloadUrl = "";
    await uploadTask.then(
        (snapshot) async => downloadUrl = await snapshot.ref.getDownloadURL());

    await user
        .updatePhotoURL(downloadUrl)
        .onError((error, stackTrace) => success = false);

    await Database().updatePhotoUrl(
      user.uid,
      downloadUrl,
      state,
      city,
    );

    return success;
  }

  static bool isFreelancer = false;

  static MyUser _convertDocSnapshot(DocumentSnapshot doc) {
    return MyUser(
      uid: doc["uid"],
      name: doc["name"],
      email: doc["email"],
      photoUrl: doc["photoUrl"],
      state: doc["state"],
      city: doc["city"],
      tags: doc["tags"] ?? [],
      rating: doc["rating"].toDouble() ?? 0,
      workDone: doc["workDone"].toInt() ?? 0,
    );
  }

  static Future<MyUser> getParticularUserDetails(String uid) async {
    return _convertDocSnapshot(
        await Database().db.collection("users").doc(uid).get());
  }

  static List<MyUser> _convertSnapshots(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return MyUser(
          uid: doc["uid"],
          name: doc["name"],
          email: doc["email"],
          photoUrl: doc["photoUrl"],
          state: doc["state"],
          city: doc["city"],
          rating: doc["rating"].toDouble(),
          workDone: doc["workDone"],
          tags: doc["tags"],
        );
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<MyUser>> getAllUsersDetails({
    required String state,
    required String city,
  }) async {
    bool success = true;
    QuerySnapshot? snapshot;
    try {
      snapshot = await Database()
          .db
          .collection("states")
          .doc(state)
          .collection("city")
          .doc(city)
          .collection("freelancers")
          .get();
    } catch (e) {
      print(e);
      success = false;
    }
    if (success)
      return _convertSnapshots(snapshot!);
    else
      return [];
  }
}
