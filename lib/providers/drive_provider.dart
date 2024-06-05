import 'package:flutter/material.dart';
import 'package:donation_app/api/firebase_drive_api.dart';
import 'package:donation_app/models/drive_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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

  void editDrive(String title, String description, List<String> donationIds,
      DateTime endDate, List<String> photos) async {
    String message = await firebaseService.editDrive(
        _selectedDrive!.id, title, description, donationIds, endDate, photos);
    print(message);
    notifyListeners();
  }

  void deleteDrive() async {
    String message = await firebaseService.deleteDrive(_selectedDrive!.id);
    print(message);
    notifyListeners();
  }

  Future<String> uploadFile(File file) async {
    try {
      // get reference to firebase storage
      final storageRef = FirebaseStorage.instance.ref();

      // get filename of the image
      final fileName = file.path.split("/").last;
      final timestamp = DateTime.now().microsecondsSinceEpoch;

      // define the path in the storage
      final uploadRef = storageRef.child("drive/$timestamp-$fileName");
      await uploadRef.putFile(file);
      print('Successfully uploaded file');
      return '$timestamp-$fileName';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<List<String>> uploadFiles(List<File> files) async {
    List<String> uploadedPaths = [];

    try {
      // Get reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Upload each file in the list
      for (File file in files) {
        // Get filename of the image
        final fileName = file.path.split("/").last;
        final timestamp = DateTime.now().microsecondsSinceEpoch;

        // Define the path in the storage
        final uploadRef = storageRef.child("drives/$timestamp-$fileName");

        // Upload file to Firebase Storage
        await uploadRef.putFile(file);

        // Add uploaded file path to the list
        uploadedPaths.add('$timestamp-$fileName');
        print('Successfully uploaded file: $fileName');
      }

      return uploadedPaths;
    } catch (e) {
      print(e);
      return ['error'];
    }
  }

  Future<void> deleteFiles(List<String> fileUrls) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      for (String fileUrl in fileUrls) {
        final fileRef = storageRef.storage.refFromURL(fileUrl);
        await fileRef.delete();
        print('Successfully deleted file: $fileUrl');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> fetchDownloadURLsForImages(
      List<String> filenames) async {
    List<String> downloadURLs = [];
    for (String filename in filenames) {
      String downloadURL = await FirebaseStorage.instance
          .ref()
          .child('drives/$filename')
          .getDownloadURL();
      downloadURLs.add(downloadURL);
    }
    return downloadURLs;
  }

  Future<DocumentSnapshot> getDriveById(String orgId) async {
    try {
      return await firebaseService.getDriveById(orgId);
    } catch (e) {
      throw Exception("Failed to retrieve drive: ${e.toString()}");
    }
  }

  Future<String?> getDriveTitle(String driveId) async {
    return firebaseService.getDriveTitleById(driveId);
  }
}
