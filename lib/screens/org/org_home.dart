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

    // execute initialization of the stream after the layout is completed
    // https://stackoverflow.com/questions/49466556/flutter-run-method-on-widget-build-complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().fetchDonationsToOrg(orgId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // access donations in the provider
    Stream<QuerySnapshot> donationsStream =
        context.watch<DonationProvider>().donationsToOrg;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    IconData getIconForStatus(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Icons.remove_circle_outline;
        case 'confirmed':
        case 'scheduled for pickup':
          return Icons.check_circle_outline;
        case 'completed':
          return Icons.check_circle;
        case 'cancelled':
          return Icons.cancel;
        default:
          return Icons.error;
      }
    }

    // TODO: Update colors
    Color getColorForStatus(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return Color(0xFFEE9D13);
        case 'confirmed':
        case 'scheduled for pickup':
          return Color(0xFF0760B8);
        case 'completed':
          return Color(0xFF8EA72E);
        case 'cancelled':
          return Color(0xFFE0554B);
        default:
          return Colors.black;
      }
    }

    // TODO: make stream builder

    return StreamBuilder(
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
            return Center(
                child: const Text(
              'No friends yet!',
              style: TextStyle(fontSize: 18),
            ));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Donation donation = Donation.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              donation.id = snapshot.data?.docs[index].id;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donation.donorId, // TODO: Change to donor name
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, // Limit name to one line
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Donated on ${DateFormat('MMMM dd, yyyy').format(donation.timestamp)}',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: donation.categories
                                // Limit the categories to at most 3 sinceall categories will be displayed in the donation details
                                .take(3)
                                .map((category) {
                              return Chip(
                                label: Text(
                                  category,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide.none,
                                labelStyle: TextStyle(color: Colors.white),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 8),
                          // TODO: Display mode only in the donation details page
                          // Row(
                          //   children: [
                          //     Icon(Icons.directions_car),
                          //     SizedBox(width: 4),
                          //     Text(
                          //       '{donation.mode.toLowerCase()}',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(width: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                getIconForStatus(donation.status),
                                color: getColorForStatus(donation.status),
                              ),
                              SizedBox(width: 4),
                              Text(
                                donation.status.substring(0, 1).toUpperCase() +
                                    donation.status.substring(1).toLowerCase(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: getColorForStatus(donation.status),
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
