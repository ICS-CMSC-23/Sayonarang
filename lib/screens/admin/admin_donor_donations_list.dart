import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/admin_provider.dart'; // Import the admin provider
import 'admin_donor_donation_details.dart';

class DonorDonationsList extends StatelessWidget {
  final String donorId;

  const DonorDonationsList({Key? key, required this.donorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch donations by donor when the widget is built
    final donationProvider =
        Provider.of<DonationProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    donationProvider.fetchDonationsByDonor(donorId);

    return StreamBuilder(
      stream: donationProvider.donationsByDonor,
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
              'No donations found!',
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

            return FutureBuilder<DocumentSnapshot>(
              future: adminProvider.getOrgById(donation.orgId ?? ''),
              builder: (context, orgSnapshot) {
                if (orgSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text('Loading organization...'),
                    subtitle: Text('Status: ${donation.status}'),
                  );
                } else if (orgSnapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading organization'),
                    subtitle: Text('Status: ${donation.status}'),
                  );
                } else {
                  var orgData =
                      orgSnapshot.data!.data() as Map<String, dynamic>?;
                  String orgName = orgData?['name'] ?? 'Unknown Organization';

                  return ListTile(
                    title: Text(orgName),
                    subtitle: Text('Status: ${donation.status}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationDetailScreen(
                              donation: donation, orgName: orgName),
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
