import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/admin_provider.dart';
import 'admin_donation_details.dart';

class DonorDonationsList extends StatelessWidget {
  final String donorId;

  const DonorDonationsList({Key? key, required this.donorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
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

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            Donation donation = Donation.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);

            IconData leadingIcon;
            Color statusColor;

            switch (donation.status) {
              case 'pending':
                leadingIcon = Icons.remove_circle;
                statusColor = const Color.fromARGB(255, 213, 138, 26);
                break;
              case 'confirmed':
                leadingIcon = Icons.check_circle;
                statusColor = Colors.blue;
                break;
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  var orgData =
                      orgSnapshot.data!.data() as Map<String, dynamic>?;
                  String orgName = orgData?['name'] ?? 'Unknown Organization';

                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      },
    );
  }
}
