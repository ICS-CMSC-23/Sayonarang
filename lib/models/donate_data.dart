class DonateData {
  final String? id;
  final String? orgId;
  final String? donorId;
  final String? driveId;
  final List<String> categories;
  final String mode;
  final List<String> addresses;
  final String contactNum;
  final String weight;
  final String photo;
  final String date;
  final String time;
  String status;

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
      weight: data['weight'] ?? '',
      photo: data['photo'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      status: data['status'] ?? '',
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
      'date': date,
      'time': time,
      'status': status,
    };
  }
}
