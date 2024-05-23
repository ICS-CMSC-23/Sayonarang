import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:donation_app/providers/donation_provider.dart';
import 'package:donation_app/models/donation_model.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  _OrgHomePageState createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  // TODO: Use id of logged in org user
  final String orgId = 'dPA5rWi1FbcTElkLvoLw6lt91t12';

  @override
  void initState() {
    super.initState();

    // Execute initialization of the stream after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().fetchDonationsToOrg(orgId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access donations in the provider
    Stream<QuerySnapshot> donationsStream =
        context.watch<DonationProvider>().donationsToOrg;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Donations",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Confirmed"),
              Tab(text: "Scheduled"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: donationsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No donations yet!',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Convert data from donations stream to a list
            List<Donation> donations = snapshot.data!.docs.map((doc) {
              Donation donation =
                  Donation.fromJson(doc.data() as Map<String, dynamic>);
              donation.id = doc.id;
              return donation;
            }).toList();

            return TabBarView(
              children: [
                _buildDonationList(donations, 'pending'),
                _buildDonationList(donations, 'confirmed'),
                _buildDonationList(donations, 'scheduled for pickup'),
                _buildDonationList(donations, 'cancelled'),
                _buildDonationList(donations, 'completed'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDonationList(List<Donation> donations, String status) {
    List<Donation> filteredDonations = donations.where((donation) {
      return donation.status.toLowerCase() == status.toLowerCase();
    }).toList();

    return ListView.builder(
      itemCount: filteredDonations.length,
      itemBuilder: (context, index) {
        Donation donation = filteredDonations[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () {
              // Navigate to the donation details page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DonationDetailsPage(donation: donation),
              //   ),
              // );
            },
            child: Card(
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation.donorId, // TODO: Change to donor name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limit name to one line
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Donated on ${DateFormat('MMMM dd, yyyy').format(donation.timestamp)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: donation.categories.take(3).map((category) {
                        return Chip(
                          label: Text(category),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          side: BorderSide.none,
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
