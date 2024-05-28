import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/donate_data.dart';
import '../api/firebase_donor_api.dart';

class DonorProvider with ChangeNotifier {
  int _selectedIndex = 0;
  List<DonateData> _donationsList = [];
  Map<String, String> _orgNames = {};
  late Stream<QuerySnapshot> _donorStream;
  late Stream<QuerySnapshot> _orgStream;

  final FirebaseDonorAPI firebaseService = FirebaseDonorAPI();

  int get selectedIndex => _selectedIndex;
  List<DonateData> get donationsList => _donationsList;
  Map<String, String> get orgNames => _orgNames;

  DonorProvider() {
    fetchDonors();
    fetchOrgs();
  }

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Stream<QuerySnapshot> get donorList => _donorStream;
  Stream<QuerySnapshot> get orgList => _orgStream;

  void fetchDonors() {
    _donorStream = firebaseService.getDonor();
    notifyListeners();
  }

  void fetchOrgs() {
    _orgStream = firebaseService.getAllOrgs();
    notifyListeners();
  }

  Future<void> fetchOrgNames() async {
    try {
      QuerySnapshot snapshot = await firebaseService.getAllOrgs().first;
      _populateOrgNames(snapshot);
    } catch (e) {
      print('Error fetching organization names: $e');
    }
  }

  void _populateOrgNames(QuerySnapshot snapshot) {
    _orgNames.clear();
    for (var doc in snapshot.docs) {
      _orgNames[doc.id] = doc['name'] ?? 'Unnamed Organization';
    }
    notifyListeners();
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    try {
      return await firebaseService.getUserById(userId);
    } catch (e) {
      throw Exception("Failed to retrieve user: ${e.toString()}");
    }
  }

  Future<void> fetchDonationsByDonor(String donorId) async {
    try {
      await fetchOrgNames(); // Fetch organization names first
      QuerySnapshot snapshot =
          await firebaseService.getDonationsByDonor(donorId);
      _donationsList = snapshot.docs
          .map((doc) => DonateData.fromMap(doc.data() as Map<String, dynamic>,
              id: doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching donations by donor: $e');
    }
  }

  Future<void> deleteDonation(String donationId) async {
    try {
      await firebaseService.deleteDonation(donationId);
      _donationsList.removeWhere((donation) => donation.id == donationId);
      notifyListeners();
    } catch (e) {
      print('Error deleting donation: $e');
    }
  }

  // Instead of deleting update the status to cancelled
  Future<void> cancelDonation(String donationId, String status) async {
    try {
      await firebaseService.cancelDonation(donationId, status);
      // _donationsList.removeWhere((donation) => donation.id == donationId);
      notifyListeners();
    } catch (e) {
      print('Error cancelling donation: $e');
    }
  }
}
