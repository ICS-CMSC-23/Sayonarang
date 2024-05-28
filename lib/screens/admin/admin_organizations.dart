import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';
import 'admin_user_details.dart';

class ViewOrganizations extends StatefulWidget {
  const ViewOrganizations({Key? key}) : super(key: key);

  @override
  State<ViewOrganizations> createState() => _ViewOrganizationsState();
}

class _ViewOrganizationsState extends State<ViewOrganizations> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> orgsStream = context.watch<AdminProvider>().orgList;

    return Scaffold(
      body: StreamBuilder(
        stream: orgsStream,
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
                'No organizations yet!',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              User org = User.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);
              org.id = snapshot.data!.docs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.business,
                        size: 40, color: Color.fromARGB(255, 254, 238, 237)),
                  ),
                  title: Text(
                    org.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    org.username,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsView(user: org),
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
