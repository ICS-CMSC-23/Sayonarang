import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_admin_api.dart';

class AdminProvider with ChangeNotifier {
  // For Bottom nav
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
  late Stream<QuerySnapshot> _pendingStream;
  late Stream<QuerySnapshot> _rejectedStream;

  // Getters
  Stream<QuerySnapshot> get donorList => _donorStream;
  Stream<QuerySnapshot> get orgList => _orgStream;
  Stream<QuerySnapshot> get pendingList => _pendingStream;
  Stream<QuerySnapshot> get rejectedList => _rejectedStream;

  fetchDonors() {
    _donorStream = firebaseService.getAllDonors();
    notifyListeners();
  }

  fetchOrgs() {
    _orgStream = firebaseService.getAllOrgs();
    notifyListeners();
  }

  fetchPending() {
    _pendingStream = firebaseService.getAllPending();
    notifyListeners();
  }

  fetchRejected() {
    _rejectedStream = firebaseService.getAllRejected();
    notifyListeners();
  }

  // Constructor initializes the FirebaseTodoAPI instance and fetches the list of donors and org.
  AdminProvider() {
    firebaseService = FirebaseAdminAPI();
    fetchDonors();
    fetchOrgs();
    fetchPending();
    fetchRejected();
  }

  void updateOrgStatus(String orgId, String status) async {
    String message =
        await firebaseService.updateOrganizationStatus(orgId, status);
    print(message);
    notifyListeners();
  }

  Future<DocumentSnapshot> getOrgById(String orgId) async {
    return firebaseService.getOrganizationById(orgId);
  }

  Future<DocumentSnapshot> getDonorById(String orgId) async {
    return firebaseService.getOrganizationById(orgId);
  }

  Future<String?> getProofImageUrl(String filename) async {
    return firebaseService.getProofImageUrl(filename);
  }
}
