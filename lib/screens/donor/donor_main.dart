import "package:flutter/material.dart";
import "package:donation_app/screens/donor/donor_donate.dart";
import "package:donation_app/screens/donor/donor_profile.dart";
import "package:donation_app/screens/donor/donor_home.dart";


class DonorMainPage extends StatefulWidget {
  const DonorMainPage({super.key});

  @override
  State<DonorMainPage> createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  // implementation based on https://www.youtube.com/watch?v=xN5GhJ7QJjc
  int currentPage = 0;

  List<Widget> pages = [
    const DonorHomePage(),
    const DonorDonatePage(),
    DonorProfileWidget()
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake),
              label: 'Donation Drives',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ));
  }
}
