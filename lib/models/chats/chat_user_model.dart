import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';

class ChatUserModel {
  static List<ChatUser> _convertSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ChatUser(
        uid: doc["uid"],
        name: doc["name"],
        photoUrl: doc["photoUrl"],
        email: doc["email"],
      );
    }).toList();
  }

  static Stream<List<ChatUser>> getChats(String uid) {
    return Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("chats")
        .snapshots()
        .map(_convertSnapshots);
  }
}

class ChatUser {
  final String uid;
  final String name;
  final String photoUrl;
  final String email;

  ChatUser(
      {required this.uid,
      required this.name,
      required this.photoUrl,
      required this.email});
}
