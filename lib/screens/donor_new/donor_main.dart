import "package:donation_app/screens/donor_new/donor_donations.dart";
import "package:donation_app/screens/donor_new/donor_home.dart";
import "package:donation_app/screens/donor_new/donor_profile.dart";
import "package:flutter/material.dart";

class DonorMainPage extends StatefulWidget {
  const DonorMainPage({super.key});

  @override
  State<DonorMainPage> createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  int currentPage = 0;

  List<Widget> pages = [
    const DonorHomePage(),
    const DonorDonationsPage(),
    const DonorProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Organizations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake),
              label: 'Donations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }
}
