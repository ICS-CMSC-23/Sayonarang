class DonorProfileModel {
  final String name;
  final String username;
  final String contactNum;
  final List<String> addresses; 

  DonorProfileModel({
    required this.name,
    required this.username,
    required this.contactNum,
    required this.addresses,
  });

  factory DonorProfileModel.fromMap(Map<String, dynamic> map) {
    return DonorProfileModel(
      name: map['name'],
      username: map['username'],
      contactNum: map['contactNum'],
      addresses: List<String>.from(map['addresses']),
    );
  }
}
