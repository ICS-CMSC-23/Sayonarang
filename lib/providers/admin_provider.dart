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

  // Fetching Donors and Organization
  late FirebaseAdminAPI firebaseService;
  late Stream<QuerySnapshot> _donorStream;
  late Stream<QuerySnapshot> _orgStream;

  // Constructor initializes the FirebaseTodoAPI instance and fetches the list of donors and org.
  AdminProvider() {
    firebaseService = FirebaseAdminAPI();
    fetchDonors();
    fetchOrgs();
  }

  Stream<QuerySnapshot> get donorList => _donorStream;
  Stream<QuerySnapshot> get orgList => _orgStream;

  fetchDonors() {
    _donorStream = firebaseService.getAllDonors();
    notifyListeners();
  }

  fetchOrgs() {
    _orgStream = firebaseService.getAllOrgs();
    notifyListeners();
  }
}
