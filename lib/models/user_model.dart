import 'dart:convert';

class User {
  String? id;
  String name;
  String username;
  List<String> addresses;
  List<String> contactNumber;
  String proof;
  String role; // admin, donor, org

  User({
    this.id,
    required this.name,
    required this.username,
    required this.addresses, // TODO: only for donor and org, decide if required or not
    required this.contactNumber, // TODO: only for donor and org, decide if required or not
    required this.proof, // TODO: only for org, decide if required or not
    required this.role,
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      addresses: json['addresses'],
      contactNumber: json['contactNumber'],
      proof: json['proof'],
      role: json['role'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'username': user.username,
      'addresses': user.addresses,
      'contactNumber': user.contactNumber,
      'proof': user.proof,
      'role': user.role,
    };
  }
}
