import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:donation_app/screens/org/org_navbar.dart';

class Donation {
  final String donorId;
  final String donorName;
  final List<String> categories;
  final String mode;
  final double weight;
  final String photoUrl;
  final String date;
  final String time;
  final String address;
  final String contactNumber;
  final String status;

  Donation({
    required this.donorId,
    required this.donorName,
    required this.categories,
    required this.mode,
    required this.weight,
    required this.photoUrl,
    required this.date,
    required this.time,
    required this.address,
    required this.contactNumber,
    required this.status,
  });
}

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});
  @override
  _OrgHomePageState createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // TODO: Fetch donations from database
    final List<Donation> donations = [
      Donation(
        donorId: '1',
        donorName: 'John Doe',
        categories: ['Food', 'Necessities'],
        mode: "pickup",
        weight: 0.5,
        photoUrl:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
        date: '2022-05-23',
        time: '10:00 AM',
        address: '123 Main St, City',
        contactNumber: '123-456-7890',
        status: "pending",
      ),
      Donation(
        donorId: '2',
        donorName: 'Jane Smith',
        categories: ['Clothing', 'Books', 'Books', 'Books', 'Books'],
        mode: "drop-off",
        weight: 1.0,
        photoUrl: 'https://example.com/photo2.jpg',
        date: '2022-05-24',
        time: '11:00 AM',
        address: '456 Elm St, Town',
        contactNumber: '987-654-3210',
        status: "confirmed",
      ),
      Donation(
        donorId: '2',
        donorName: 'Jane Smith',
        categories: ['Clothing', 'Books', 'Books', 'Books', 'Books'],
        mode: "drop-off",
        weight: 1.0,
        photoUrl: 'https://example.com/photo2.jpg',
        date: '2022-05-24',
        time: '11:00 AM',
        address: '456 Elm St, Town',
        contactNumber: '987-654-3210',
        status: "confirmed",
      ),
      Donation(
        donorId: '2',
        donorName: 'Jane Smith',
        categories: ['Clothing', 'Books', 'Books', 'Books', 'Books'],
        mode: "drop-off",
        weight: 1.0,
        photoUrl: 'https://example.com/photo2.jpg',
        date: '2022-05-24',
        time: '11:00 AM',
        address: '456 Elm St, Town',
        contactNumber: '987-654-3210',
        status: "confirmed",
      ),
    ];

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

    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
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
                      donation.donorName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Limit name to one line
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Donated on ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(donation.date))}',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
  }
}
