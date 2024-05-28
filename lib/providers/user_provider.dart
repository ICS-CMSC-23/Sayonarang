import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:donation_app/api/firebase_user_api.dart';
import 'dart:io';

class MyAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;
  String? role;

  Map<String, dynamic> signupStatus = {};
  Map<String, dynamic> userDetails =
      {}; // {success: true/false, response: map/string}

  MyAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();

    // get user role based on id
    uStream.first.then((user) async {
      if (user != null) {
        print('## User ID: ${user.uid}');

        role = await authService.getUserRole(user.uid);
        print('## Role: $role');
        notifyListeners();
      }
    });

    notifyListeners();
  }

  Future<void> signUp(
      String name,
      String username,
      String email,
      String password,
      String contactNum,
      List<String> addresses,
      String proof,
      String role) async {
    signupStatus = await authService.signUp(
        name, username, email, password, contactNum, addresses, proof, role);
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    userDetails = await authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  Future<File?> getImageFromGallery(BuildContext context) async {
    try {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnImage == null) return null;
      // print(returnImage.path);
      return File(returnImage.path);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      // get reference to firebase storage
      final storageRef = FirebaseStorage.instance.ref();

      // get filename of the image
      final fileName = file.path.split("/").last;
      final timestamp = DateTime.now().microsecondsSinceEpoch;

      // define the path in the storage
      final uploadRef = storageRef.child("proof/$timestamp-$fileName");
      await uploadRef.putFile(file);
      print('Successfully uploaded file');
      return '$timestamp-$fileName';
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      Map<String, dynamic> userDoc = await authService.getUserDetails(userId);
      return userDoc;
    } catch (e) {
      throw Exception("Failed to retrieve details of user: ${e.toString()}");
    }
  }

  Future<String> getUserRole(String userId) async {
    try {
      role = await authService.getUserRole(userId);
      notifyListeners();
      return role ?? '';
    } catch (e) {
      throw Exception("Failed to retrieve role of user: ${e.toString()}");
    }
  }
}
