import 'package:flutter/material.dart';
import 'package:donation_app/screens/org/org_navbar.dart';

class OrgDonationDrivesPage extends StatefulWidget {
  const OrgDonationDrivesPage({super.key});
  @override
  _OrgDonationDrivesPageState createState() => _OrgDonationDrivesPageState();
}

class _OrgDonationDrivesPageState extends State<OrgDonationDrivesPage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Text("Org Donation Drives"),
      bottomNavigationBar: OrgBottomNavigationBar(currentIndex: 1),
    );
  }
}
