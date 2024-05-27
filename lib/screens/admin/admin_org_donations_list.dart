import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/donation_model.dart';
import '../../models/drive_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/drive_provider.dart';
import '../../providers/admin_provider.dart'; // Import the admin provider
import 'admin_donation_details.dart';
import 'admin_drive_details.dart';

class OrgDonationsList extends StatelessWidget {
  final String orgId;

  const OrgDonationsList({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final donationProvider =
        Provider.of<DonationProvider>(context, listen: false);
    final driveProvider = Provider.of<DriveProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    donationProvider.fetchDonationsToOrg(orgId);
    driveProvider.fetchDrivesByOrg(orgId);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSection(context, driveProvider.drivesByOrg, adminProvider,
              'Donation Drives', false),
          _buildSection(context, donationProvider.donationsToOrg, adminProvider,
              'All Donations', true),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, Stream<QuerySnapshot> stream,
      AdminProvider adminProvider, String title, bool isDonation) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error encountered! ${snapshot.error}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $title found!',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                if (isDonation) {
                  Donation donation = Donation.fromJson(
                      snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);
                  return _buildDonationListItem(
                      context, donation, adminProvider);
                } else {
                  Drive drive = Drive.fromJson(snapshot.data!.docs[index].data()
                      as Map<String, dynamic>);
                  return _buildDriveListItem(context, drive, adminProvider);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonationListItem(
      BuildContext context, Donation donation, AdminProvider adminProvider) {
    return FutureBuilder<DocumentSnapshot>(
      future: adminProvider.getDonorById(donation.donorId),
      builder: (context, donorSnapshot) {
        if (donorSnapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text('Loading organization...'),
            subtitle: Text('Status: ${donation.status}'),
          );
        } else if (donorSnapshot.hasError) {
          return ListTile(
            title: Text('Error loading organization'),
            subtitle: Text('Status: ${donation.status}'),
          );
        } else {
          var donorData = donorSnapshot.data!.data() as Map<String, dynamic>?;
          String donorName = donorData?['name'] ?? 'Unknown Organization';

          return ListTile(
            title: Text(donorName),
            subtitle: Text('Status: ${donation.status}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationDetailScreen(
                      donation: donation,
                      userName: donorName,
                      userRole: 'Organization'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildDriveListItem(
      BuildContext context, Drive drive, AdminProvider adminProvider) {
    return FutureBuilder<DocumentSnapshot>(
      future: adminProvider.getOrgById(drive.orgId!),
      builder: (context, orgSnapshot) {
        if (orgSnapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text('Loading organization...'),
            subtitle: Text('Description: ${drive.description}'),
          );
        } else if (orgSnapshot.hasError) {
          return ListTile(
            title: Text('Error loading organization'),
            subtitle: Text('Description: ${drive.description}'),
          );
        } else {
          var orgData = orgSnapshot.data!.data() as Map<String, dynamic>?;
          String orgName = orgData?['name'] ?? 'Unknown Organization';

          return ListTile(
            title: Text(drive.title),
            subtitle: Text('Description: ${drive.description}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriveScreen(
                    drive: drive,
                    userName: orgName,
                    // userRole: 'Organization'
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
