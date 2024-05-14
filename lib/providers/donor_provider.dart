import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/models/donor_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonorProfileProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DonorProfileModel? _donorProfile;

  String get donorName => _donorProfile?.name ?? '';
  String get username => _donorProfile?.username ?? '';

  DonorProfileProvider() {
    fetchDonorProfile();
  }

  Stream<DonorProfileModel?> get donorProfileStream {

    final userId = "vy0ppldmGdadSHa1vhxHoX2bwk13";
    //final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print('Fetching donor profile for user ID: $userId');
      return _firestore
          .collection('users')
          .where('role', isEqualTo: 'donor')
          .where('uid', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        print('Donor profile snapshot: $snapshot');
        if (snapshot.docs.isNotEmpty) {
          final donorProfile = DonorProfileModel.fromMap(snapshot.docs.first.data());
          print('Donor profile: $donorProfile');
          return donorProfile;
        } else {
          return null;
        }
      });
    } else {
      print('No user ID found');
      return Stream.value(null);
    }
  }

  void fetchDonorProfile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef = _firestore.collection('users').where('role', isEqualTo: 'donor').where('uid', isEqualTo: userId);
      final userSnapshot = await userRef.get();
      if (userSnapshot.docs.isNotEmpty) {
        _donorProfile = DonorProfileModel.fromMap(userSnapshot.docs.first.data());
        print('Donor profile fetched: $_donorProfile');
        notifyListeners();
      }
    }
  }
}