import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonorAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDonor() {
    return db.collection("users").where("role", isEqualTo: "donor").snapshots();
  }

  Stream<QuerySnapshot> getAllOrgs() {
    return db
        .collection("users")
        .where("role", isEqualTo: "org")
        .where("status", isEqualTo: "approved")
        .snapshots();
  }

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

  // New method to retrieve user data by ID
  Future<DocumentSnapshot> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();
      return userDoc;
    } on FirebaseException catch (e) {
      throw Exception("Failed to retrieve user: ${e.message}");
    }
  }
}
