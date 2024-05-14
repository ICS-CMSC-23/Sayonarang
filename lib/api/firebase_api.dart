import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/donate_data.dart';

class FirebaseSlamAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDataApi(DonateData data) async {
    try {
      await db.collection("Friends").add(data.data);
      return "Successfully added data!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

   Future<String> editData(DonateData data) async {
    try {
      await db.collection("Friends").doc(data.id).update(data.data);
      return "Successfully updated data!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("Friends").snapshots();
  }

  Future<String> deleteFriend(String? id) async {
  try {
    await db.collection("Friends").doc(id).delete();

    return "Successfully deleted!";
  } on FirebaseException catch (e) {
    return "Failed with error '${e.code}: ${e.message}";
  }
}

}
