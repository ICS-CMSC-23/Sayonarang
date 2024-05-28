import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';
import 'admin_user_details.dart';

class ViewDonors extends StatefulWidget {
  const ViewDonors({Key? key}) : super(key: key);

  @override
  State<ViewDonors> createState() => _ViewDonorsState();
}

class _ViewDonorsState extends State<ViewDonors> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> donorsStream =
        context.watch<AdminProvider>().donorList;

    return Scaffold(
      body: StreamBuilder(
        stream: donorsStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error encountered! ${snapshot.error}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No donors yet!',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              User donor = User.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              donor.id = snapshot.data!.docs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.account_box_rounded,
                      size: 40, color: Color(0xFF4CAF50)),
                  title: Text(
                    donor.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    donor.username,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsView(user: donor),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
