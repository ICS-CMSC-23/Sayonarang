import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';
import 'admin_waitlist_details.dart';
// import 'pending_org_detail_page.dart';

class AdminApprovalWaitList extends StatefulWidget {
  const AdminApprovalWaitList({Key? key}) : super(key: key);

  @override
  State<AdminApprovalWaitList> createState() => _AdminApprovalWaitListState();
}

class _AdminApprovalWaitListState extends State<AdminApprovalWaitList> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildOrganizationList(
            context,
            provider.pendingList,
            'Pending Organizations',
            Icons.access_time,
            Colors.orange,
          ),
          _buildOrganizationList(
            context,
            provider.rejectedList,
            'Rejected Organizations',
            Icons.cancel,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationList(
    BuildContext context,
    Stream<QuerySnapshot> stream,
    String title,
    IconData icon,
    Color iconColor,
  ) {
    return StreamBuilder(
      stream: stream,
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
                  'No $title...',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                if (title == 'Pending Organizations')
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AdminProvider>(context, listen: false)
                          .updateIndex(1);
                    },
                    child: Text("View Approved Organizations"),
                  ),
              ],
            ),
          );
        }

        return Card(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: iconColor.withOpacity(0.1),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  User org = User.fromJson(snapshot.data!.docs[index].data()
                      as Map<String, dynamic>);
                  org.id = snapshot.data!.docs[index].id;

                  return ListTile(
                    leading: Icon(
                      icon,
                      size: 40,
                      color: iconColor,
                    ),
                    title: Text(
                      org.name,
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PendingOrgDetailPage(org: org),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
