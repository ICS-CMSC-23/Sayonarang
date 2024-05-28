import 'package:flutter/material.dart';
import 'package:donation_app/api/firebase_drive_api.dart';
import 'package:donation_app/models/drive_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriveProvider with ChangeNotifier {
  late FirebaseDriveAPI firebaseService;
  late Stream<QuerySnapshot> _drivesStream;
  late Stream<QuerySnapshot> _drivesByOrgStream;
  Drive? _selectedDrive;

  DriveProvider() {
    firebaseService = FirebaseDriveAPI();
    fetchDrives();
    _drivesStream = const Stream
        .empty(); // initialize with an empty stream to prevent LateInitializationError
    _drivesByOrgStream = const Stream.empty();
  }

  // getter
  Stream<QuerySnapshot> get drives => _drivesStream;
  Stream<QuerySnapshot> get drivesByOrg => _drivesByOrgStream;
  Drive get selected => _selectedDrive!;

  changeSelectedDrive(Drive drive) {
    _selectedDrive = drive;
  }

  void fetchDrives() {
    _drivesStream = firebaseService.getAllDrives();
    notifyListeners();
  }

  void fetchDrivesByOrg(String orgId) {
    _drivesByOrgStream = firebaseService.getDrivesByOrg(orgId);
    notifyListeners();
  }

  void addDrive(Drive drive) async {
    String message = await firebaseService.addDrive(drive.toJson());
    print(message);
    notifyListeners();
  }

  void editDrive(String title, String description, List<String> driveIds,
      DateTime endDate) async {
    String message = await firebaseService.editDrive(
        _selectedDrive!.id, title, description, driveIds, endDate);
    print(message);
    notifyListeners();
  }

  void deleteDrive() async {
    String message = await firebaseService.deleteDrive(_selectedDrive!.id);
    print(message);
    notifyListeners();
  }
}
