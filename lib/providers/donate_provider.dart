import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donate_data.dart';
import '../api/firebase_api.dart';

class DonateDataProvider with ChangeNotifier {
  final FirebaseSlamAPI firebaseService = FirebaseSlamAPI();
  late Stream<QuerySnapshot> _dataStream;
  final List<DonateData> _dataList = [];

  int get donationsCount => _dataList.length;
  List<DonateData> get donations => _dataList;

  DonateDataProvider() {
    fetchData();
  }

  Stream<QuerySnapshot> get dataStream => _dataStream;

  void fetchData() {
    _dataStream = firebaseService.getAllDonations();
    _dataStream.listen((snapshot) {
      _dataList.clear();
      for (var doc in snapshot.docs) {
        _dataList.add(DonateData.fromMap(doc.data() as Map<String, dynamic>, id: doc.id));
      }
      notifyListeners();
    }, onError: (error) {
      print('Error fetching donations: $error');
    });
  }
  

  Future<void> addDonation(DonateData donation) async {
    try {
      String message = await firebaseService.addDataApi(donation);
      print(message);
      _dataList.add(donation);
      notifyListeners();
    } catch (e) {
      print('Error adding donation: $e');
      rethrow;
    }
  }

  Future<void> updateDonation(DonateData donation) async {
    try {
      String message = await firebaseService.editData(donation);
      print(message);
      int index = _dataList.indexWhere((d) => d.id == donation.id);
      if (index != -1) {
        _dataList[index] = donation;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating donation: $e');
      rethrow;
    }
  }

  Future<void> deleteDonation(String id) async {
    try {
      String message = await firebaseService.deleteDonation(id);
      print(message);
      _dataList.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting donation: $e');
      rethrow;
    }
  }
}
