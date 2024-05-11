import 'package:flutter/material.dart';
import 'package:donation_app/api/firebase_donation_api.dart';
import 'package:donation_app/models/donation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationProvider with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationsStream;

  DonationProvider() {
    firebaseService = FirebaseDonationAPI();
    fetchDonations();
  }

  // getter
  Stream<QuerySnapshot> get donations => _donationsStream;

  void fetchDonations() {
    _donationsStream = firebaseService.getAllDonations();
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
