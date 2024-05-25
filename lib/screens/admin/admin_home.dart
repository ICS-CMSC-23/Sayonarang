import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/user_provider.dart';
import '../auth/login_page.dart';
import 'admin_donors.dart';
import 'admin_organizations.dart';
import 'admin_profile.dart';
import 'admin_waitlist.dart';
import 'package:flutter/cupertino.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  static const List<String> _pageTitles = [
    'Approval Wait list',
    'Organizations',
    'Donors'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[provider.selectedIndex]),
      ),
      body: _AdminPages.elementAt(provider.selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () {
                // Handle Log out tap
                // Implement log out logic here
                context.read<MyAuthProvider>().signOut(); // Log-out
                // Go to Log-in
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_on_clipboard),
            label: 'Approval Waitlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Organizations',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
            label: 'Donors',
          ),
        ],
        currentIndex: provider.selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) => provider.updateIndex(index),
      ),
    );
  }

  static List<Widget> _AdminPages = <Widget>[
    AdminApprovalWaitList(),
    ViewOrganizations(),
    ViewDonors(),
  ];
}
