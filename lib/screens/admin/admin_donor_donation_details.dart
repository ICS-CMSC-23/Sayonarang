import 'package:flutter/material.dart';
import '../../models/donation_model.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;
  final String orgName;

  const DonationDetailScreen(
      {Key? key, required this.donation, required this.orgName})
      : super(key: key);

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
            Text('Organization: $orgName'),
            Text('Categories: ${donation.categories.join(', ')}'),
            Text('Addresses: ${donation.addresses.join(', ')}'),
            Text('Mode: ${donation.mode}'),
            Text('Weight: ${donation.weight} kg'),
            Text('Contact Number: ${donation.contactNum}'),
            Text('Status: ${donation.status}'),
          ],
        ),
      ),
    );
  }
}
