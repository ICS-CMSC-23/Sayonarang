import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class OrgAccountDetails extends StatelessWidget {
  final User org;

  const OrgAccountDetails({Key? key, required this.org}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
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
          SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
