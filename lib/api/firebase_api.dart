import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donate_data.dart';

class FirebaseSlamAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getAllDonations() {
    return _firestore.collection('donations').snapshots();
  }

  Future<String> addDataApi(DonateData donation) async {
    try {
      await _firestore.collection('donations').add(donation.toMap());
      return 'Donation added successfully';
    } catch (e) {
      print('Error adding donation: $e');
      throw e;
    }
  }

  Future<String> editData(DonateData donation) async {
    try {
      await _firestore.collection('donations').doc(donation.id).update(donation.toMap());
      return 'Donation updated successfully';
    } catch (e) {
      print('Error updating donation: $e');
      throw e;
    }
  }

  Future<String> deleteDonation(String id) async {
    try {
      await _firestore.collection('donations').doc(id).delete();
      return 'Donation deleted successfully';
    } catch (e) {
      print('Error deleting donation: $e');
      throw e;
    }
  }
}
