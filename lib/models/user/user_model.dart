import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  static String defaultPhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/task-bridge-f9e1f.appspot.com/o/user%2Fprofile%2Fdefault-avatar.png?alt=media&token=a96179ea-75fa-46e6-9155-90cacea732e0";
  static FirebaseStorage storage = FirebaseStorage.instance;
  // FirebaseStorage(storageBucket: "gs://task-bridge-f9e1f.appspot.com");
  static Future<bool> updateProfilePhoto(File file, User user) async {
    bool success = true;
    var storageRef = storage.ref().child("user/profile/${user.uid}");
    var uploadTask = storageRef.putFile(file);
    String downloadUrl = "";
    await uploadTask.then(
        (snapshot) async => downloadUrl = await snapshot.ref.getDownloadURL());

    await user
        .updatePhotoURL(downloadUrl)
        .onError((error, stackTrace) => success = false);
    return success;
  }

  static bool isFreelancer = false;
}
