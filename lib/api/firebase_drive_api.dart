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

  Future<String> editDrive(String? id, String title, String description,
      DateTime endDate, List<String> photos) async {
    try {
      await db.collection("drives").doc(id).update({
        "title": title,
        "description": description,
        "endDate": endDate,
        "photos": photos,
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

  Future<DocumentSnapshot> getDriveById(String driveId) async {
    try {
      DocumentSnapshot driveDoc =
          await db.collection('drives').doc(driveId).get();
      return driveDoc;
    } on FirebaseException catch (e) {
      throw Exception("Failed to retrieve user: ${e.message}");
    }
  }

  // Retrieve drive name by id
  Future<String?> getDriveTitleById(String driveId) async {
    try {
      DocumentSnapshot doc = await db.collection('drives').doc(driveId).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return data['title'];
      }
      return null;
    } catch (e) {
      print("Failed to retrieve drive name: $e");
      return null;
    }
  }
}
