import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';

class PendingOrgDetailPage extends StatelessWidget {
  final User org;

  const PendingOrgDetailPage({Key? key, required this.org}) : super(key: key);

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organization Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFF54741),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF54741)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'ACCOUNT DETAILS',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(
                          Icons.business,
                          size: 40,
                        ),
                        title: Text(
                          org.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        subtitle: Text(
                          org.username,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Text(
                            org.status,
                            style: TextStyle(
                              fontSize: 16,
                              color: getStatusColor(org.status),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Contact Number:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Text(
                            org.contactNum,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Addresses:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: org.addresses.map((address) {
                          return Row(
                            children: [
                              const SizedBox(width: 15),
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
                      const SizedBox(height: 8),
                      const Text(
                        'Proof:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<String?>(
                        future: adminProvider.getProofImageUrl(org.proof),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final imageUrl = snapshot.data;
                            if (imageUrl != null) {
                              return Image.network(
                                imageUrl,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Text('Image not found');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      adminProvider.updateOrgStatus(org.id!, 'approved');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    child: const Text('Approve'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      adminProvider.updateOrgStatus(org.id!, 'rejected');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFE53935),
                    ),
                    child: const Text('Disapprove'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
