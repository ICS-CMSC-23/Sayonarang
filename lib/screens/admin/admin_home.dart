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

  static List<Widget> _AdminPages = <Widget>[
    AdminApprovalWaitList(),
    ViewOrganizations(),
    ViewDonors(),
  ];

  static const Color customRed = Color(0xFFF54741);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[provider.selectedIndex],
          style: const TextStyle(
            color: customRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _AdminPages.elementAt(provider.selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: customRed,
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
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
        selectedItemColor: customRed, // Set the selected item color to Red
        onTap: (index) => provider.updateIndex(index),
      ),
    );
  }
}
