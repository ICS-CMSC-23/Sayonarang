import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';

class UserAccountDetails extends StatelessWidget {
  final User user;

  const UserAccountDetails({Key? key, required this.user}) : super(key: key);

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
    final bool isDonor = user.role == 'donor';

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
                    leading: Container(
                      width: 50, // Adjust the width and height as needed
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue, // Change color as needed
                        borderRadius:
                            BorderRadius.circular(8), // Make it square
                      ),
                      child: Icon(
                        isDonor ? Icons.person : Icons.business,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    subtitle: Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
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
                        user.contactNum,
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
                    children: user.addresses.map((address) {
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
                  if (!isDonor) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Proof:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<String?>(
                      future: adminProvider.getProofImageUrl(user.proof),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
