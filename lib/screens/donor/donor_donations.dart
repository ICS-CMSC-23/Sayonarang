import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/admin_provider.dart';
import 'donation_details.dart';

class ShowDonations extends StatelessWidget {
  const ShowDonations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Center(
        child: Text(
          "No user is currently signed in",
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    final String donorId = currentUser.uid;
    donationProvider.fetchDonationsByDonor(donorId);

    return DefaultTabController(
      length: 5, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Donations'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Scheduled'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: donationProvider.donationsByDonor,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error encountered! ${snapshot.error}",
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No donations found!',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            List<Donation> donations = snapshot.data!.docs.map((doc) {
              return Donation.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();

            return TabBarView(
              children: [
                _buildDonationList(donations, 'pending', adminProvider),
                _buildDonationList(donations, 'confirmed', adminProvider),
                _buildDonationList(donations, 'scheduled', adminProvider),
                _buildDonationList(donations, 'completed', adminProvider),
                _buildDonationList(donations, 'cancelled', adminProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationList(List<Donation> donations, String status, AdminProvider adminProvider) {
    List<Donation> filteredDonations = donations.where((donation) {
      return donation.status.toLowerCase() == status.toLowerCase();
    }).toList();

    if (filteredDonations.isEmpty) {
      return Center(
        child: Text(
          'No $status donations found!',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredDonations.length,
      itemBuilder: (context, index) {
        Donation donation = filteredDonations[index];

        IconData leadingIcon;
        Color statusColor;

        switch (donation.status) {
          case 'pending':
            leadingIcon = Icons.remove_circle;
            statusColor = const Color.fromARGB(255, 213, 138, 26);
            break;
          case 'confirmed':
          case 'scheduled':
            leadingIcon = Icons.check_circle;
            statusColor = Colors.blue;
            break;
          case 'completed':
            leadingIcon = Icons.check_circle;
            statusColor = Colors.green;
            break;
          case 'cancelled':
            leadingIcon = Icons.cancel;
            statusColor = Colors.red;
            break;
          default:
            leadingIcon = Icons.error;
            statusColor = Colors.black;
        }

        return FutureBuilder<DocumentSnapshot>(
          future: adminProvider.getOrgById(donation.orgId),
          builder: (context, orgSnapshot) {
            if (orgSnapshot.connectionState == ConnectionState.waiting) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(
                    leadingIcon,
                    color: statusColor,
                  ),
                  title: const Text('Loading organization...'),
                  subtitle: Text('Status: ${donation.status}'),
                ),
              );
            } else if (orgSnapshot.hasError) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(
                    leadingIcon,
                    color: statusColor,
                  ),
                  title: const Text('Error loading organization'),
                  subtitle: Text('Status: ${donation.status}'),
                ),
              );
            } else {
              var orgData = orgSnapshot.data!.data() as Map<String, dynamic>?;
              String orgName = orgData?['name'] ?? 'Unknown Organization';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(
                    leadingIcon,
                    color: statusColor,
                  ),
                  title: Text(
                    orgName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Status: ${donation.status}',
                        style: TextStyle(color: statusColor),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: donation.categories
                            .take(3) // Limit to three categories
                            .map(
                              (category) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationDetailScreen(
                          donation: donation,
                          userName: orgName,
                          userRole: 'Donor',
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}
