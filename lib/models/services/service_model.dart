import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_bridge/models/database/database.dart';

class ServiceModel {
  static List<Service> _convertSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Service(
        name: doc["name"],
        desc: doc["desc"],
        price: doc["price"].toDouble(),
        active: doc["active"],
        timestamp: doc["timestamp"].toDate(),
        link: doc["link"],
      );
    }).toList();
  }

  static Stream<List<Service>> getServices(String uid) {
    return Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("services")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(_convertSnapshots);
  }

  static Future changeServiceState(String uid, String docId, bool val) async {
    bool success = true;
    await Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("services")
        .doc(docId)
        .update({
      "active": val,
    }).onError((error, stackTrace) {
      print(error);
      success = false;
    });
    return success;
  }

  static Future addService({
    required String uid,
    required String name,
    required String desc,
    required double price,
    required String link,
  }) async {
    String er = "";
    DateTime today = DateTime.now();
    await Database()
        .db
        .collection("users")
        .doc(uid)
        .collection("services")
        .doc(today.millisecondsSinceEpoch.toString())
        .set({
      "name": name,
      "desc": desc,
      "price": price,
      "link": link,
      "timestamp": today,
      "active": true,
    }).onError((error, stackTrace) => er = error.toString());
    return er;
  }
}

class Service {
  final String name;
  final String desc;
  final double price;
  final bool active;
  final DateTime timestamp;
  final String link;

  Service({
    required this.name,
    required this.desc,
    required this.price,
    required this.active,
    required this.timestamp,
    required this.link,
  });
}
