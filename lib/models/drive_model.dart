import 'dart:convert';

class Drive {
  String? id;
  final String? orgId; // id of org who created the donation drive
  String title;
  String description;
  List<String>
      donationIds; // list of donation ids for when the org links donations to donation drives

  Drive({
    this.id,
    required this.orgId,
    required this.title,
    required this.description,
    required this.donationIds,
  });

  // Factory constructor to instantiate object from json format
  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      id: json['id'],
      orgId: json['orgId'],
      title: json['title'],
      description: json['description'],
      donationIds: json['donationIds'],
    );
  }

  static List<Drive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Drive>((dynamic d) => Drive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Drive donationDrive) {
    return {
      'orgId': donationDrive.orgId,
      'title': donationDrive.title,
      'description': donationDrive.description,
      'donationIds': donationDrive.donationIds,
    };
  }
}
