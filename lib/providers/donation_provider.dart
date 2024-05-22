import 'package:flutter/material.dart';
import 'package:donation_app/api/firebase_donation_api.dart';
import 'package:donation_app/models/donation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationProvider with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationsStream;
  late Stream<QuerySnapshot> _donationsByDonorStream;
  late Stream<QuerySnapshot> _donationsToOrgStream;

  DonationProvider() {
    firebaseService = FirebaseDonationAPI();
    // Initialize streams with empty streams to avoid late initialization errors
    // _donationsStream = Stream<QuerySnapshot>.empty();
    // _donationsByDonorStream = Stream<QuerySnapshot>.empty();
    // _donationsToOrgStream = Stream<QuerySnapshot>.empty();
  }

  // getter
  Stream<QuerySnapshot> get donations => _donationsStream;
  Stream<QuerySnapshot> get donationsByDonor => _donationsByDonorStream;
  Stream<QuerySnapshot> get donationsToOrg => _donationsToOrgStream;

  void fetchDonations() {
    _donationsStream = firebaseService.getAllDonations();
    notifyListeners();
  }

  void fetchDonationsByDonor(String donorId) {
    _donationsByDonorStream = firebaseService.getDonationsByDonor(donorId);
    notifyListeners();
  }

  void fetchDonationsToOrg(String orgId) {
    _donationsToOrgStream = firebaseService.getDonationsToOrg(orgId);
    notifyListeners();
  }

  void addDonation(Donation donation) async {
    String message =
        await firebaseService.addDonation(donation.toJson(donation));
    print(message);
    notifyListeners();
  }

  void editDonation(String id, String status) async {
    String message = await firebaseService.editDonation(id, status);
    print(message);
    notifyListeners();
  }

  void deleteDonation(String id) async {
    String message = await firebaseService.deleteDonation(id);
    print(message);
    notifyListeners();
  }
}
