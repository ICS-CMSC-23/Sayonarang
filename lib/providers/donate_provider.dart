import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/donate_data.dart';
import '../api/firebase_api.dart';

class DonateDatacart with ChangeNotifier {
  late FirebaseSlamAPI firebaseService;
  late Stream<QuerySnapshot> _dataStream;
  final List<DonateData> _dataList = [];
  
  int _friendsCount = 0;
  List<DonateData> get friends => _dataList;

  DonateDatacart () {
    firebaseService = FirebaseSlamAPI();
    fetchData();
  }

  Stream<QuerySnapshot> get dataStream => _dataStream;

  void fetchData() {
    _dataStream = firebaseService.getAllFriends();
    notifyListeners();
  }

  void addData(DonateData d) async {
    String message = await firebaseService.addDataApi(d);
    print(message);
    _friendsCount++;
    notifyListeners();
  } 

  void updateData(DonateData d) async {
    String message = await firebaseService.editData(d);
    print(message);
    notifyListeners();
  }

  void delete(String nameAndNickname) async {
    String message = await firebaseService.deleteFriend(nameAndNickname);
    print(message);
  notifyListeners();
}

  void removeAll() {
    _dataList.clear();
    _friendsCount = 0;
    notifyListeners();
  }

  void removeData(String name) {
    for (int i = 0; i < _dataList.length; i++) {
      if (_dataList[i].data["Name"] == name) {
        _friendsCount--;
        _dataList.remove(_dataList[i]);
        break;
      }
    }
    notifyListeners();
  }
}

