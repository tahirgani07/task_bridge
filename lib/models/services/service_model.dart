import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';

class ServiceModel {
  static Future<String> sendService({
    required String creatorUid,
    required String combinedUid,
    required String name,
    required String desc,
    required double price,
  }) async {
    String er = "";
    Timestamp today = Timestamp.now();
    Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("services")
        .doc(today.millisecondsSinceEpoch.toString())
        .set({
      "creatorUid": creatorUid,
      "name": name,
      "desc": desc,
      "price": price,
      "active": false,
      "completed": false,
      "timestamp": today,
    }).onError((error, stackTrace) {
      er = error.toString();
    });

    return er;
  }

  static List<Service> _convertSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Service(
        creatorUid: doc["creatorUid"],
        name: doc["name"],
        desc: doc["desc"],
        price: doc["price"].toDouble(),
        active: doc["active"],
        timestamp: doc["timestamp"].toDate(),
        completed: doc["completed"],
      );
    }).toList();
  }

  static Stream<List<Service>> getServices(String combinedUid) {
    return Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("services")
        // .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_convertSnapshots);
  }

  static Future<bool> acceptService(String combinedUid, Service service) async {
    bool success = true;
    Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("services")
        .doc(service.timestamp.millisecondsSinceEpoch.toString())
        .update({
      "active": true,
    }).onError((error, stackTrace) {
      print(error.toString());
      success = false;
    });

    return success;
  }

  static Future<bool> serviceCompleted(
      String combinedUid, Service service) async {
    bool success = true;
    Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("services")
        .doc(service.timestamp.millisecondsSinceEpoch.toString())
        .delete()
        .onError((error, stackTrace) {
      print(error.toString());
      success = false;
    });

    return success;
  }

  static Future<bool> deleteService(String combinedUid, Service service) async {
    bool success = true;
    Database()
        .db
        .collection("all-chats")
        .doc(combinedUid)
        .collection("services")
        .doc(service.timestamp.millisecondsSinceEpoch.toString())
        .update({
      "completed": true,
    }).onError((error, stackTrace) {
      print(error.toString());
      success = false;
    });

    return success;
  }

  // static List<Service> _convertSnapshots(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return Service(
  //       name: doc["name"],
  //       desc: doc["desc"],
  //       price: doc["price"].toDouble(),
  //       active: doc["active"],
  //       timestamp: doc["timestamp"].toDate(),
  //     );
  //   }).toList();
  // }

  // static Stream<List<Service>> getServices(String uid) {
  //   return Database()
  //       .db
  //       .collection("users")
  //       .doc(uid)
  //       .collection("services")
  //       .orderBy("timestamp", descending: true)
  //       .snapshots()
  //       .map(_convertSnapshots);
  // }

  // static Future changeServiceState(String uid, String docId, bool val) async {
  //   bool success = true;
  //   await Database()
  //       .db
  //       .collection("users")
  //       .doc(uid)
  //       .collection("services")
  //       .doc(docId)
  //       .update({
  //     "active": val,
  //   }).onError((error, stackTrace) {
  //     print(error);
  //     success = false;
  //   });
  //   return success;
  // }

  // static Future addService({
  //   required String uid,
  //   required String name,
  //   required String desc,
  //   required double price,
  // }) async {
  //   String er = "";
  //   DateTime today = DateTime.now();
  //   await Database()
  //       .db
  //       .collection("users")
  //       .doc(uid)
  //       .collection("services")
  //       .doc(today.millisecondsSinceEpoch.toString())
  //       .set({
  //     "name": name,
  //     "desc": desc,
  //     "price": price,
  //     "timestamp": today,
  //     "active": true,
  //   }).onError((error, stackTrace) => er = error.toString());
  //   return er;
  // }
}

class Service {
  final String creatorUid;
  final String name;
  final String desc;
  final double price;
  final bool active;
  final bool completed;
  final DateTime timestamp;

  Service({
    required this.creatorUid,
    required this.name,
    required this.desc,
    required this.price,
    required this.active,
    required this.completed,
    required this.timestamp,
  });
}
