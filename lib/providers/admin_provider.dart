import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_admin_api.dart';

class AdminProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Fetching Donors
  late FirebaseAdminAPI firebaseService;
  late Stream<QuerySnapshot> _donorStream;

// Constructor initializes the FirebaseTodoAPI instance and fetches the list of friends.
  AdminProvider() {
    firebaseService = FirebaseAdminAPI();
    fetchDonors();
  }

  Stream<QuerySnapshot> get donorList => _donorStream;

  fetchDonors() {
    _donorStream = firebaseService.getAllDonors();
    notifyListeners();
  }
}
