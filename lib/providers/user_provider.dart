import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_user_api.dart';

class MyAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  String message = '';

  MyAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();

    notifyListeners();
  }

  Future<void> signUp(
      String name,
      String username,
      String email,
      String password,
      String contactNum,
      // List<String> addresses,
      String addresses,
      String proof,
      String role) async {
    await authService.signUp(
        name, username, email, password, contactNum, addresses, proof, role);
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    message = await authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
