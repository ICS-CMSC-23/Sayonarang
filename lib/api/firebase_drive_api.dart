import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDrive(Map<String, dynamic> drive) async {
    try {
      await db.collection("drives").add(drive);

      return "Successfully added donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDrives() {
    return db.collection("drives").snapshots();
  }

  Stream<QuerySnapshot> getDrivesByOrg(String orgId) {
    try {
      return db
          .collection("drives")
          .where("orgId", isEqualTo: orgId)
          .snapshots();
    } catch (e) {
      throw "Failed to get donation drives by org: $e";
    }
  }

  // the donation drive can be edited to update its description and list of donations linked
  Future<String> editDrive(String? id, String title, String description,
      List<String> donationIds, DateTime endDate) async {
    try {
      print("Description: $description");
      print("Donation IDs: $donationIds");
      await db.collection("drives").doc(id).update({
        "title": title,
        "description": description,
        "donationIds": donationIds,
        "endDate": endDate
      });

      return "Successfully edited donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteDrive(String? id) async {
    try {
      await db.collection("drives").doc(id).delete();

      return "Successfully deleted donation drive!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
