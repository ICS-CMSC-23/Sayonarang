import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:donation_app/models/donate_data.dart';
import 'package:donation_app/providers/donor_provider.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/screens/donor/donor_qrcode.dart';


class DonationDetailScreen extends StatelessWidget {
  final DonateData donation;
  final String userName;
  final String userRole;

  const DonationDetailScreen({
    Key? key,
    required this.donation,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donation Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFF54741),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF54741)),
      ),
      body: Padding(
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
                        userRole == 'Donor' ? 'Organization: $userName' : 'Donor: $userName',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildStatusText(donation.status),
                    const SizedBox(height: 15),
                    const Text(
                      'Categories:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: donation.categories.map((categories) {
                        return Row(
                          children: [
                            const SizedBox(width: 25),
                            Text(
                              categories,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    if (donation.mode != "Drop-off") // Only show if mode is not "Drop-off"
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            'Addresses:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: donation.addresses.map((address) {
                              return Row(
                                children: [
                                  const SizedBox(width: 25),
                                  Text(
                                    address,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Contact Number:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 25),
                              Text(
                                donation.contactNum,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 15),
                    const Text(
                      'Mode:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          donation.mode,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Weight:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          '${donation.weight}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(donation.date),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Text(
                          donation.time,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (donation.mode == "Drop-off")
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QrCodeScreen(donationId: donation.id!),
                              ),
                            );
                          },
                          child: Text('Show QR'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: donation.status != 'cancelled' && donation.status != 'completed'
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Provider.of<DonorProvider>(context, listen: false)
                    .cancelDonation(donation.id!, 'cancelled');
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Donation Cancelled'),
                    duration: Duration(seconds: 1),
                  ),
                );
                Provider.of<DonorProvider>(context, listen: false);
              },
              label: Text('Cancel Donation'),
              icon: Icon(Icons.cancel),
              backgroundColor: Colors.red,
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildStatusText(String status) {
    Color statusColor = Colors.black;

    switch (status) {
      case 'pending':
        statusColor = const Color.fromARGB(255, 213, 138, 26);
        break;
      case 'confirmed':
        statusColor = Colors.blue;
        break;
      case 'scheduled':
        statusColor = Colors.blue;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.black;
        break;
    }

    return Text(
      'Status: $status',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: statusColor,
      ),
    );
  }
}
