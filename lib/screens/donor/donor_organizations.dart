import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/donor_provider.dart';
import 'donor_donate.dart';

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
                Text(
                  'No organizations yet!',
                  style: TextStyle(
                    fontSize: 20, 
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonorDonatePage(organization: org),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.supervised_user_circle_sharp,
                      size: 40,
                    ), 
                    title: Text(
                      org.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22, 
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


