import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';

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
}

class Chat {
  final String uid;
  final String message;
  final DateTime timestamp;

  Chat(this.uid, this.message, this.timestamp);
}
