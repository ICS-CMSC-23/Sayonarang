import 'package:flutter/material.dart';
import 'package:donation_app/screens/donor/donor_navbar.dart';

class DonorDonatePage extends StatefulWidget {
  const DonorDonatePage({super.key});
  @override
  __DonorDonatePageStateState createState() => __DonorDonatePageStateState();
}

class __DonorDonatePageStateState extends State<DonorDonatePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Text("Org Donation Drives"),
      bottomNavigationBar: DonorBottomNavigationBar(currentIndex: 1),
    );
  }
}
