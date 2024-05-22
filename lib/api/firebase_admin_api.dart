import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdminAPI {
  // A class that provides methods to interact with Firebase Firestore for friend-related operations.
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Retrieves a stream of all donors from the Firestore collection.
  Stream<QuerySnapshot> getAllDonors() {
    return db.collection("users").where("role", isEqualTo: "donor").snapshots();
  }

  // Retrieves a stream of all approved orgs from the Firestore collection.
  Stream<QuerySnapshot> getAllOrgs() {
    return db
        .collection("users")
        .where("role", isEqualTo: "org")
        .where("status", isEqualTo: "approved")
        .snapshots();
  }

  // Retrieves a stream of all approved orgs from the Firestore collection.
  Stream<QuerySnapshot> getAllPending() {
    return db
        .collection("users")
        .where("role", isEqualTo: "org")
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  // Retrieves a stream of all rejected orgs from the Firestore collection.
  Stream<QuerySnapshot> getAllRejected() {
    return db
        .collection("users")
        .where("role", isEqualTo: "org")
        .where("status", isEqualTo: "rejected")
        .snapshots();
  }

  // Retrieve specific org by id
  Future<DocumentSnapshot<Map<String, dynamic>>> getOrganizationById(
      String orgId) async {
    return db.collection('users').doc(orgId).get();
  }

  // Retrieve specific donor by id
  Future<DocumentSnapshot<Map<String, dynamic>>> getDonorById(
      String donorId) async {
    return db.collection('users').doc(donorId).get();
  }

  // Edits a friend's information in the Firestore collection.
  Future<String> editFriend(
      String? id,
      String nickname,
      int age,
      bool isInRelationship,
      int happiness,
      String superpower,
      String motto) async {
    try {
      print("New Nickname: $nickname");
      await db.collection("friends").doc(id).update({"nickname": nickname});

      print("New Age: $age");
      await db.collection("friends").doc(id).update({"age": age});

      print("New Relationship status: $isInRelationship");
      await db
          .collection("friends")
          .doc(id)
          .update({"isInRelationship": isInRelationship});

      print("New happiness level: $happiness");
      await db.collection("friends").doc(id).update({"happiness": happiness});

      print("New Superpower: $superpower");
      await db.collection("friends").doc(id).update({"superpower": superpower});

      print("New Motto: $motto");
      await db.collection("friends").doc(id).update({"motto": motto});

      return "Successfully edited friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updateOrganizationStatus(String orgId, String status) async {
    try {
      await db.collection('users').doc(orgId).update({
        'status': status,
      });

      return "Successfully updated organization status to $status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
