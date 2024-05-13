//admin_donors.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';

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
                // Display a message if there are no donors
                Text(
                  'No donors yet!',
                  style: TextStyle(
                    fontSize: 20, // Increased font size for no donors message
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate the height of the container based on the number of donors
        // double containerHeight = (snapshot.data!.docs.length * 600.0) + 32.0;

        return Container(
          // height: containerHeight,
          // margin: EdgeInsets.all(16.0),
          // padding: EdgeInsets.all(8.0),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12.0),
          //   color: Color.fromARGB(255, 227, 227, 227),
          // ),
          child: ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              User donor = User.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              donor.userId = snapshot.data!.docs[index].id;

              return Container(
                child: InkWell(
                  onTap: () {
                    // TODO: Implement navigating to user details
                  },
                  child: ListTile(
                    leading: Icon(
                      // CupertinoIcons.person_crop_circle_fill,
                      Icons.account_box_rounded,
                      size: 40,
                    ), // Icon for the person/account

                    title: Text(
                      donor.name,
                      style: TextStyle(
                        fontSize: 22, // Adjusted font size for donor name
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      donor.username,
                      style: TextStyle(
                        fontSize: 16, // Adjusted font size for username
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      // TODO: Implement navigating to user details
                    },
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
