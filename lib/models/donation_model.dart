import 'dart:convert';

class Donation {
  String? id;
  final String donorId; // id of user who made the donation
  final String orgId; // id of user whom the donation will be given to
  final String
      driveId; // id of donation drive where the org linked the donation to
  List<String>
      categories; // food, clothes, cash, necessities, others (can add as necessary)
  List<String> addresses;
  String mode; // pickup or drop-off
  double weight; // weight in kg
  String contactNumber;
  String
      status; // pending, confirmed, scheduled for pick-up, completed, cancelled
  // TODO: Add time and date fields

  Donation({
    this.id,
    required this.donorId,
    required this.orgId,
    required this.driveId,
    required this.categories,
    required this.addresses,
    required this.mode,
    required this.weight,
    required this.contactNumber,
    required this.status,
  });

  // Factory constructor to instantiate object from json format
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      donorId: json['donorId'],
      orgId: json['orgId'],
      driveId: json['driveId'],
      categories: json['categories'],
      addresses: json['addresses'],
      mode: json['mode'],
      weight: json['weight'],
      contactNumber: json['contactNumber'],
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
      'driveId': donation.driveId,
      'categories': donation.categories,
      'addresses': donation.addresses,
      'mode': donation.mode,
      'weight': donation.weight,
      'contactNumber': donation.contactNumber,
      'status': donation.status,
    };
  }
}
