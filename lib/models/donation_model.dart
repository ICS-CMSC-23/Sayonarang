import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  String? id;
  final String donorId; // id of user who made the donation, will not change
  final String
      orgId; // id of user whom the donation will be given to, will not change (assigned when donation is made)
  String driveId; // id of donation drive where the org linked the donation to
  List<String>
      categories; // Food, Clothes, Cash, Necessities, others (can add as necessary)
  List<String> addresses;
  String mode; // Pick-up or Drop-off
  double weight; // weight in kg
  String weightUnit; // kg, lbs
  String contactNum;
  String
      status; // pending, confirmed, scheduled for pick-up, completed, cancelled
  DateTime date;
  String time;
  DateTime timestamp; // date of when the donor made the donation
  String photo;

  Donation({
    this.id,
    required this.donorId,
    required this.orgId,
    required this.driveId,
    required this.categories,
    required this.addresses,
    required this.mode,
    required this.weight,
    required this.weightUnit,
    required this.contactNum,
    required this.status,
    required this.date,
    required this.time,
    required this.timestamp,
    required this.photo,
  });

  // Factory constructor to instantiate object from json format
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      donorId: json['donorId'],
      orgId: json['orgId'],
      driveId: json['driveId'],
      categories: (json['categories'] as List)
          .cast<String>(), // convert List<dynamic> to List<String>
      addresses: (json['addresses'] as List).cast<String>(),
      mode: json['mode'],
      weight: json['weight'].toDouble(),
      weightUnit: json['weightUnit'],
      contactNum: json['contactNum'],
      status: json['status'],
      date: json['date'].toDate(), // convert Firebase Timestamp to DateTime
      time: json['time'],
      timestamp: json['timestamp'].toDate(),
      photo: json['photo'],
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
      'weightUnit': donation.weightUnit,
      'contactNum': donation.contactNum,
      'status': donation.status,
      'date': donation.date,
      'time': donation.time,
      'timestamp': donation.timestamp,
      'photo': donation.photo,
    };
  }
}
