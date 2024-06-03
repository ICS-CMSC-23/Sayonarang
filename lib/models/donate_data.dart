import 'package:cloud_firestore/cloud_firestore.dart';

class DonateData {
  final String? id;
  final String? orgId;
  final String? donorId;
  final String? driveId;
  final List<String> categories;
  final String mode;
  final List<String> addresses;
  final String contactNum;
  double weight;
  final String photo;
  DateTime date;
  final String time;
  String status;
  DateTime timestamp;
  String weightUnit;

  DonateData({
    this.id,
    required this.orgId,
    required this.donorId,
    required this.driveId,
    required this.categories,
    required this.mode,
    required this.addresses,
    required this.contactNum,
    required this.weight,
    required this.photo,
    required this.date,
    required this.time,
    this.status = 'pending',
    required this.timestamp,
    required this.weightUnit,
  });

  factory DonateData.fromMap(Map<String, dynamic> data, {String? id}) {
    return DonateData(
      id: id,
      orgId: data['orgId'] ?? '',
      donorId: data['donorId'] ?? '',
      driveId: data['driveId'] ?? '',
      categories: List<String>.from(data['categories'] ?? []),
      mode: data['mode'] ?? '',
      addresses: List<String>.from(data['addresses'] ?? []),
      contactNum: data['contactNum'] ?? '',
      weight: (data['weight'] ?? 0.0).toDouble(),
      photo: data['photo'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      weightUnit: data['weightUnit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orgId': orgId,
      'donorId': donorId,
      'driveId': driveId,
      'categories': categories,
      'mode': mode,
      'addresses': addresses,
      'contactNum': contactNum,
      'weight': weight,
      'photo': photo,
      'date': Timestamp.fromDate(date),
      'time': time,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'weightUnit': weightUnit,
    };
  }
}
