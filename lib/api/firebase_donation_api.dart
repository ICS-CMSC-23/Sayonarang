import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async {
    try {
      await db.collection("donations").add(donation);

      return "Successfully added donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonations() {
    return db.collection("donations").snapshots();
  }

  Stream<QuerySnapshot> getDonationsByDonor(String donorId) {
    try {
      return db
          .collection("donations")
          .where("donorId", isEqualTo: donorId)
          .snapshots();
    } catch (e) {
      throw "Failed to get donations by donor: $e";
    }
  }

  Stream<QuerySnapshot> getDonationsToOrg(String orgId) {
    try {
      return db
          .collection("donations")
          .where("orgId", isEqualTo: orgId)
          .snapshots();
    } catch (e) {
      throw "Failed to get donations to org: $e";
    }
  }

  // TODO: add api for getting donations given categories as a filter

  // the donation can be edited only to update its status
  Future<String> editDonation(
    String? id,
    String status,
  ) async {
    try {
      print("Status: $status");
      await db.collection("donations").doc(id).update({
        "status": status,
      });

      return "Successfully edited donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteDonation(String? id) async {
    try {
      await db.collection("donations").doc(id).delete();

      return "Successfully deleted donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
