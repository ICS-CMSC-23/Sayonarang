import 'package:flutter/material.dart';
import 'package:donation_app/api/firebase_drive_api.dart';
import 'package:donation_app/models/drive_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriveProvider with ChangeNotifier {
  late FirebaseDriveAPI firebaseService;
  late Stream<QuerySnapshot> _drivesStream;
  late Stream<QuerySnapshot> _drivesByOrgStream;

  DriveProvider() {
    firebaseService = FirebaseDriveAPI();
    // fetchDrives();
  }

  // getter
  Stream<QuerySnapshot> get drives => _drivesStream;
  Stream<QuerySnapshot> get drivesByOrg => _drivesByOrgStream;

  void fetchDrives() {
    _drivesStream = firebaseService.getAllDrives();
    notifyListeners();
  }

  void fetchDrivesByOrg(String orgId) {
    _drivesByOrgStream = firebaseService.getDrivesByOrg(orgId);
    notifyListeners();
  }

  void addDrive(Drive drive) async {
    String message = await firebaseService.addDrive(drive.toJson(drive));
    print(message);
    notifyListeners();
  }

  void editDrive(String id, String description, List<String> driveIds) async {
    String message = await firebaseService.editDrive(id, description, driveIds);
    print(message);
    notifyListeners();
  }

  void deleteDrive(String id) async {
    String message = await firebaseService.deleteDrive(id);
    print(message);
    notifyListeners();
  }
}
