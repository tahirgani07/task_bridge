import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';

class ServiceModel {
  static Future<String> sendService({
    required String creatorUid,
    required String createdForUid,
    required String combinedUid,
    required String name,
    required String desc,
    required double price,
  }) async {
    bool success = true;
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
      "createdForUid": createdForUid,
    }).onError((error, stackTrace) {
      success = false;
      er = error.toString();
    });

    if (success) {
      Database()
          .db
          .collection("users")
          .doc(creatorUid)
          .collection("services")
          .doc(today.millisecondsSinceEpoch.toString())
          .set({
        "combinedUid": combinedUid,
        "docId": today.millisecondsSinceEpoch.toString(),
      }).onError((error, stackTrace) {
        er = error.toString();
      });
    }

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
        createdForUid: doc["createdForUid"],
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

  // static Future<bool> serviceCompleted(
  //     String combinedUid, Service service) async {
  //   bool success = true;
  //   Database()
  //       .db
  //       .collection("all-chats")
  //       .doc(combinedUid)
  //       .collection("services")
  //       .doc(service.timestamp.millisecondsSinceEpoch.toString())
  //       .delete()
  //       .onError((error, stackTrace) {
  //     print(error.toString());
  //     success = false;
  //   });

  //   return success;
  // }

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

  static Future<List<Service>> getParticularUsersServices(String uid) async {
    QuerySnapshot snap = await Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("services")
        .get();
    List<Service> serviceList = [];

    for (int i = 0; i < snap.docs.length; i++) {
      DocumentSnapshot serviceDoc = await Database()
          .db
          .collection("all-chats")
          .doc(snap.docs[i]["combinedUid"])
          .collection("services")
          .doc(snap.docs[i]["docId"])
          .get();

      serviceList.add(Service(
        creatorUid: serviceDoc["creatorUid"],
        name: serviceDoc["name"],
        desc: serviceDoc["desc"],
        price: serviceDoc["price"].toDouble(),
        active: serviceDoc["active"],
        timestamp: serviceDoc["timestamp"].toDate(),
        completed: serviceDoc["completed"],
        createdForUid: serviceDoc["createdForUid"],
      ));
    }
    return serviceList;
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
  final String createdForUid;
  final String name;
  final String desc;
  final double price;
  final bool active;
  final bool completed;
  final DateTime timestamp;

  Service({
    required this.creatorUid,
    required this.createdForUid,
    required this.name,
    required this.desc,
    required this.price,
    required this.active,
    required this.completed,
    required this.timestamp,
  });
}
