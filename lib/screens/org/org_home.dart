import 'package:donation_app/screens/org/org_donation_form.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    // TODO: Remove, move implementation to org profile page
    // fetch user details
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      // execute initialization of the stream after the layout is completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DonationProvider>().fetchDonationsToOrg(_currentUser!.uid);
      });
    }
  }

  Future<String> _fetchDonorName(String donorId) async {
    final userDetails =
        await context.read<MyAuthProvider>().getUserDetails(donorId);
    return userDetails['name'] as String? ?? 'Unknown Donor';
  }

  Widget _buildDonationList(List<Donation> donations, String status) {
    List<Donation> filteredDonations = donations.where((donation) {
      return donation.status.toLowerCase() == status.toLowerCase();
    }).toList();

    if (filteredDonations.isEmpty) {
      return Center(
        child: Text(
          'No ${status.toLowerCase() == 'scheduled for pick-up' ? 'scheduled' : status.toLowerCase()} donations yet!',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredDonations.length,
      itemBuilder: (context, index) {
        Donation donation = filteredDonations[index];
        return FutureBuilder<String>(
          future: _fetchDonorName(donation.donorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return const LinearProgressIndicator();
              return Container(); // TODO: Find fix for progress indicator stacking
            } else if (snapshot.hasError) {
              return Text('Error encountered! ${snapshot.error}');
            }
            String donorName = snapshot.data ?? 'Donor';
            return _buildDonationCard(donation, donorName);
          },
        );
      },
    );
  }

  Widget _buildDonationCard(Donation donation, String donorName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          // change selected donation
          context.read<DonationProvider>().changeSelectedDonation(donation);

          // navigate to the donation details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrgDonationFormPage(),
            ),
          );
        },
        child: Card(
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            title: Text(
              donorName, // display the fetched donor name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // limit name to one line
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Donated on ${DateFormat('MMMM dd, yyyy').format(donation.timestamp)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1, // limit date to one line
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  // limit categories to be displayed to 3
                  children: donation.categories.take(3).map((category) {
                    return _buildTruncatedChip(category);
                  }).toList(),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildTruncatedChip(String text) {
    const maxLength = 20;
    final truncatedText =
        text.length > maxLength ? text.substring(0, maxLength) + '...' : text;

    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      label: Text(truncatedText),
      backgroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide.none,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    // access donations in the provider
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

            // convert data from donations stream to a list
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
                _buildDonationList(donations, 'scheduled for pick-up'),
                _buildDonationList(donations, 'completed'),
                _buildDonationList(donations, 'cancelled'),
              ],
            );
          },
        ),
      ),
    );
  }
}
