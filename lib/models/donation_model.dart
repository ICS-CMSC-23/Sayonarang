import 'dart:convert';

class Donation {
  String? id;
  final String donorId; // id of user who made the donation
  final String? orgId; // id of user whom the donation will be given to
  List<String>
      categories; // food, clothes, cash, necessities, others (can add as necessary)
  List<String> addresses;
  String mode; // pickup or drop-off
  double weight; // weight in kg
  String contactNum;
  String
      status; // pending, confirmed, scheduled for pick-up, completed, cancelled

  Donation({
    this.id,
    required this.donorId,
    required this.orgId,
    required this.categories,
    required this.addresses,
    required this.mode,
    required this.weight,
    required this.contactNum,
    required this.status,
  });

  // Factory constructor to instantiate object from json format
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      donorId: json['donorId'],
      orgId: json['orgId'],
      categories: List<String>.from(
          json['categories']), // change this into a list of strings
      addresses: List<String>.from(
          json['addresses']), // change this into a list of strings
      mode: json['mode'],
      weight: (json['weight'] as num).toDouble(),
      contactNum: json['contactNum'],
      status: json['status'],
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'donorId': donation.donorId,
      'orgId': donation.orgId,
      'categories': donation.categories,
      'addresses': donation.addresses,
      'mode': donation.mode,
      'weight': donation.weight,
      'contactNum': donation.contactNum,
      'status': donation.status,
    };
  }
}
