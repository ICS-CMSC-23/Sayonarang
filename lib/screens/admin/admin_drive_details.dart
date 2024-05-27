import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../models/drive_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/donation_provider.dart';
import 'admin_donation_details.dart';
// import 'drive_donations_list.dart'; // Import the new widget

class DriveScreen extends StatefulWidget {
  final Drive drive;
  final String userName;

  const DriveScreen({
    Key? key,
    required this.drive,
    required this.userName,
  }) : super(key: key);

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  @override
  Widget build(BuildContext context) {
    // Ensure driveId is not blank before passing it
    final driveId = widget.drive.id ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userName),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Donations'),
              Tab(text: 'Drive Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pass driveId here
            DriveDonationsList(driveId: driveId),
            DriveDetailScreen(
              drive: widget.drive,
              userName: widget.userName,
            ),
          ],
        ),
      ),
    );
  }
}

// Details screen of drive
class DriveDetailScreen extends StatelessWidget {
  final Drive drive;
  final String userName;

  const DriveDetailScreen({
    Key? key,
    required this.drive,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            drive.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text('Organization: $userName'),
          SizedBox(height: 8),
          // Text('Role: $userRole'),
          SizedBox(height: 8),
          Text('Description: ${drive.description}'),
          SizedBox(height: 8),
          Text('End Date: ${drive.endDate.toLocal()}'),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class DriveDonationsList extends StatelessWidget {
  final String driveId;

  const DriveDonationsList({Key? key, required this.driveId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final donationProvider =
        Provider.of<DonationProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    donationProvider.fetchDonationsByDrive(driveId);

    return StreamBuilder(
      stream: donationProvider.donationsByDrive,
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
              'No donations found for this drive!',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            Donation donation = Donation.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);
            return _buildDonationListItem(context, donation, adminProvider);
          },
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
            title: Text('Loading donor...'),
            subtitle: Text('Status: ${donation.status}'),
          );
        } else if (donorSnapshot.hasError) {
          return ListTile(
            title: Text('Error loading donor'),
            subtitle: Text('Status: ${donation.status}'),
          );
        } else {
          var donorData = donorSnapshot.data!.data() as Map<String, dynamic>?;
          String donorName = donorData?['name'] ?? 'Unknown Donor';

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
                    userRole: 'Donor',
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
