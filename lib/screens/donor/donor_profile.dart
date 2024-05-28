import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/models/donor_profile_model.dart';
import 'package:donation_app/providers/donor_provider.dart';
import 'package:donation_app/screens/donor/donor_profileheader.dart';
import 'package:donation_app/providers/user_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DonorProfileWidget extends StatefulWidget {
  @override
  _DonorProfileWidgetState createState() => _DonorProfileWidgetState();
}

class _DonorProfileWidgetState extends State<DonorProfileWidget> {
  late User? _currentUser;
  late Future<DocumentSnapshot> _userDocFuture;
  bool _showDonations = false;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _userDocFuture = Provider.of<DonorProvider>(context, listen: false).getUserById(_currentUser!.uid);
    }
  }

  void _fetchDonations() async {
    if (_currentUser != null) {
      await Provider.of<DonorProvider>(context, listen: false).fetchDonationsByDonor(_currentUser!.uid);
      setState(() {
        _showDonations = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentUser == null
            ? Center(child: Text('No user is currently signed in'))
            : FutureBuilder<DocumentSnapshot>(
                future: _userDocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('User not found'));
                  } else {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final donorProfile = DonorProfileModel.fromMap(userData);

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          ProfileHeader(
                            donorName: donorProfile.name ?? "Name",
                            username: donorProfile.username ?? "username",
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<MyAuthProvider>().signOut();
                              },
                              child: Text('Logout'),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _fetchDonations,
                            child: Text(_showDonations ? 'Refresh' : 'Show Donations'),
                          ),
                          SizedBox(height: 20),
                          if (_showDonations) _buildDonationsList(context),
                        ],
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }

  Widget _buildDonationsList(BuildContext context) {
    final donations = Provider.of<DonorProvider>(context).donationsList;
    final orgNames = Provider.of<DonorProvider>(context).orgNames;

    if (donations.isEmpty) {
      return Center(child: Text('No donations found'));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Donations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: donations.length,
            itemBuilder: (context, index) {
              final donation = donations[index];
              final orgName = orgNames[donation.orgId] ?? 'Unknown Organization';

              if (donation.status != 'Completed') {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${orgName.toUpperCase()}',
                              style: TextStyle(fontSize: 18, color: Colors.red)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Items: ${donation.categories.join(', ')}'),
                              Text('Mode: ${donation.mode}'),
                              Text('Date: ${donation.date}'),
                              Text('Time: ${donation.time}'),
                              Text('Address: ${donation.addresses.join(', ')}'),
                              Text('Contact: ${donation.contactNum}'),
                              Text('Weight: ${donation.weight} kg'),
                              Text('Status: ${donation.status}'),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Provider.of<DonorProvider>(context, listen: false)
                                    .deleteDonation(donation.id!);
                              },
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                        if (donation.mode == "Drop-off")
                          QrImageView(
                            data: '${donation.id}',
                            version: QrVersions.auto,
                            size: 120.0,
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${orgName.toUpperCase()}',
                              style: TextStyle(fontSize: 18, color: Colors.green)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Items: ${donation.categories.join(', ')}'),
                              Text('Mode: ${donation.mode}'),
                              Text('Date: ${donation.date}'),
                              Text('Time: ${donation.time}'),
                              Text('Address: ${donation.addresses.join(', ')}'),
                              Text('Contact: ${donation.contactNum}'),
                              Text('Weight: ${donation.weight} kg'),
                              Text('Status: ${donation.status}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
