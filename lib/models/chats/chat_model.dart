import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';
import 'package:task_bridge/models/user/my_user.dart';
import 'package:task_bridge/models/user/user_model.dart';

class ChatModel {
  static List<Chat> _convertSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Chat(doc["uid"], doc["message"], doc["timestamp"].toDate());
    }).toList();
  }

  static Stream<List<Chat>> getChats(String combinedUid) {
    return Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("chats")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_convertSnapshots);
  }

  static List<String> _convertSnapshotsUsers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc["uid"].toString();
    }).toList();
  }

  static Stream<List<String>> getChatUsers(String uid) {
    return Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("chats")
        .snapshots()
        .map(_convertSnapshotsUsers);
  }
}

class Chat {
  final String uid;
  final String message;
  final DateTime timestamp;

  Chat(this.uid, this.message, this.timestamp);
}
