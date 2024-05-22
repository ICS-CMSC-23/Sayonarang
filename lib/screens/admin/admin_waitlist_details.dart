import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';

class PendingOrgDetailPage extends StatelessWidget {
  final User org;

  const PendingOrgDetailPage({Key? key, required this.org}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              org.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Username: ${org.username}'),
            SizedBox(height: 8),
            Text('Contact Number: ${org.contactNum}'),
            SizedBox(height: 8),
            Text('Addresses: ${org.addresses.join(', ')}'),
            SizedBox(height: 8),
            Text('Status: ${org.status}'),
            SizedBox(height: 8),
            // TODO: whether to use web image or file upload image as proof
            Text('Proof: ${org.proof}'), // uses file upload
            // Uses web image
            // Text(
            //   'Proof of Legitimacy',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // // Proof of legitimacy image is from the web
            // SizedBox(height: 8),
            // org.proof.isNotEmpty
            //     ? Image.network(org.proof)
            //     : Text('No proof of legitimacy provided.'),

            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    adminProvider.updateOrgStatus(org.id!, 'approved');
                    Navigator.of(context).pop();
                  },
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () {
                    adminProvider.updateOrgStatus(org.id!, 'rejected');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.red,
                      ),
                  child: Text('Disapprove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
