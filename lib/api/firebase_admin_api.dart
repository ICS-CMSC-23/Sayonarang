import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdminAPI {
  // A class that provides methods to interact with Firebase Firestore for friend-related operations.
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Retrieves a stream of all donors from the Firestore collection.
  Stream<QuerySnapshot> getAllDonors() {
    return db.collection("users").where("role", isEqualTo: "donor").snapshots();
  }

  // Adds a friend to the Firestore collection.
  // Future<String> addFriend(Map<String, dynamic> friend) async {
  //   try {
  //     await db.collection("friends").add(friend);
  //     return "Successfully added friend!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }

  // Deletes a friend from the Firestore collection by their ID.
  // Future<String> deleteFriend(String? id) async {
  //   try {
  //     await db.collection("friends").doc(id).delete();
  //     return "Successfully deleted friend!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }

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
}
