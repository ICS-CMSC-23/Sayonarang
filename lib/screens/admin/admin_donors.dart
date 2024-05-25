import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';
import 'admin_donor_details.dart';

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

    return StreamBuilder(
      stream: donorsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error encountered! ${snapshot.error}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No donors yet!',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            User donor = User.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);
            donor.id = snapshot.data!.docs[index].id;

            return ListTile(
              leading: Icon(
                Icons.account_box_rounded,
                size: 40,
              ),
              title: Text(
                donor.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                donor.username,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DonorDetailsView(donor: donor),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
