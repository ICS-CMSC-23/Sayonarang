import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_donor_api.dart';

class DonorProvider with ChangeNotifier {
  // For Bottom nav
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Fetching Donors and Organization
  final FirebaseDonorAPI firebaseService = FirebaseDonorAPI();
  late Stream<QuerySnapshot> _donorStream;
  late Stream<QuerySnapshot> _orgStream;

  // Getters
  Stream<QuerySnapshot> get donorList => _donorStream;
  Stream<QuerySnapshot> get orgList => _orgStream;

  // Fetch data methods
  void fetchDonors() {
    _donorStream = firebaseService.getDonor();
    notifyListeners();
  }

  void fetchOrgs() {
    _orgStream = firebaseService.getAllOrgs();
    notifyListeners();
  }

  // Constructor initializes the streams for donors and orgs
  DonorProvider() {
    fetchDonors();
    fetchOrgs();
  }

  // Method to fetch user by ID
  Future<DocumentSnapshot> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await firebaseService.getUserById(userId);
      return userDoc;
    } catch (e) {
      throw Exception("Failed to retrieve user: ${e.toString()}");
    }
  }
}
