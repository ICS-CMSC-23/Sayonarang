import 'package:flutter/material.dart';
import '../../models/donation_model.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;
  final String userName;
  final String userRole; // Add userRole to handle donor or organization

  const DonationDetailScreen({
    Key? key,
    required this.donation,
    required this.userName,
    required this.userRole, // Initialize userRole
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userRole == 'Donor'
                  ? 'Organization: $userName'
                  : 'Donor: $userName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Categories: ${donation.categories.join(', ')}'),
            SizedBox(height: 8),
            Text('Addresses: ${donation.addresses.join(', ')}'),
            SizedBox(height: 8),
            Text('Mode: ${donation.mode}'),
            SizedBox(height: 8),
            Text('Weight: ${donation.weight} kg'),
            SizedBox(height: 8),
            Text('Contact Number: ${donation.contactNum}'),
            SizedBox(height: 8),
            Text('Status: ${donation.status}'),
          ],
        ),
      ),
    );
  }
}
