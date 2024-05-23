// //donor_organizations.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/donor_provider.dart';

class ViewOrganizations extends StatefulWidget {
  const ViewOrganizations({Key? key}) : super(key: key);

  @override
  State<ViewOrganizations> createState() => _ViewOrganizationsState();
}

class _ViewOrganizationsState extends State<ViewOrganizations> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> orgsStream = context.watch<DonorProvider>().orgList;

    return StreamBuilder(
      stream: orgsStream,
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
                // Display a message if there are no orgs
                Text(
                  'No organizations yet!',
                  style: TextStyle(
                    fontSize: 20, // Increased font size for no org message
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          child: ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              User org = User.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);

              org.id = snapshot.data!.docs[index].id;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.verified_user_rounded,
                      size: 40,
                    ), 
                    title: Text(
                      org.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22, // Adjusted font size for donor name
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      org.username,
                      style: TextStyle(
                        fontSize: 16, 
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {

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
