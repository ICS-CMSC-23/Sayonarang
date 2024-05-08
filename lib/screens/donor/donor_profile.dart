import 'package:flutter/material.dart';
import 'package:donation_app/screens/donor/donor_navbar.dart';

class DonorProfilePage extends StatefulWidget {
  const DonorProfilePage({super.key});
  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Text("Donor's Profile"),
      bottomNavigationBar: DonorBottomNavigationBar(currentIndex: 2),
    );
  }
}
