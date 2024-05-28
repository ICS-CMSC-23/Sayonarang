import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/donation_model.dart';
import '../../models/drive_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/donation_provider.dart';
import 'admin_donation_details.dart';

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
    final driveId = widget.drive.id ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.drive.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF54741),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xFFF54741)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Donations'),
              Tab(text: 'Drive Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
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
      child: ListView(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      drive.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Organization',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    drive.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'End Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(drive.endDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
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
              future: adminProvider.getDonorById(donation.donorId),
              builder: (context, donorSnapshot) {
                if (donorSnapshot.connectionState == ConnectionState.waiting) {
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
                } else if (donorSnapshot.hasError) {
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
                  var donorData =
                      donorSnapshot.data!.data() as Map<String, dynamic>?;
                  String donorName =
                      donorData?['name'] ?? 'Unknown Organization';

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
                        donorName,
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
                              userName: donorName,
                              userRole: 'org',
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
