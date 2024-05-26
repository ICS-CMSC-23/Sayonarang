import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class DonorAccountDetails extends StatelessWidget {
  final User donor;

  const DonorAccountDetails({Key? key, required this.donor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            donor.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text('Username: ${donor.username}'),
          SizedBox(height: 8),
          Text('Contact Number: ${donor.contactNum}'),
          SizedBox(height: 8),
          Text('Addresses: ${donor.addresses.join(', ')}'),
        ],
      ),
    );
  }
}
