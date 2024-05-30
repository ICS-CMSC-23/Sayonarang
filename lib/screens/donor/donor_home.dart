import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'donor_organizations.dart';
import 'donor_profile.dart';
import 'donor_donations.dart';
import 'package:flutter/cupertino.dart';
import 'package:donation_app/providers/donor_provider.dart';

class DonorView extends StatelessWidget {
  const DonorView({super.key});

  static const List<String> _pageTitles = [
    'Available Organizations',
    'My Donations',
    'Profile'
  ];

  static const Color customRed = Color(0xFFF54741);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorProvider>(context);

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
      body: _DonorPages.elementAt(provider.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Organizations',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_on_clipboard),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: provider.selectedIndex,
        selectedItemColor: customRed,
        onTap: (index) => provider.updateIndex(index),
      ),
    );
  }

  static List<Widget> _DonorPages = <Widget>[
    ViewOrganizations(),
    ShowDonations(),
    DonorProfileWidget(),
  ];
}
