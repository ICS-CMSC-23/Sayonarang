//user_model.dart
import 'dart:convert';

class User {
  String? userId;
  String name;
  String username;
  List<String> addresses;
  String contactNum; // Renamed this to be the same in firebase
  String proof;
  String role; // admin, donor, org
  String status; // pending, approved, rejected (for org)

  User({
    this.userId,
    required this.name,
    required this.username,
    required this.addresses, // only for donor and org
    required this.contactNum, // only for donor and org
    required this.proof, // only for org
    required this.role,
    required this.status, // only for org
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    // Convert dynamic list to list of strings
    List<String> parsedAddresses =
        json['addresses'] != null ? List<String>.from(json['addresses']) : [];

    return User(
      userId: json['userId'],
      name: json['name'],
      username: json['username'],
      addresses: parsedAddresses,
      contactNum: json['contactNum'],
      proof: json['proof'],
      role: json['role'],
      status: json['status'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'username': user.username,
      'addresses': user.addresses,
      'contactNum': user.contactNum,
      'proof': user.proof,
      'role': user.role,
      'status': user.status,
    };
  }
}
