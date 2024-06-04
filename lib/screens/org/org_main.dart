import "package:donation_app/screens/org/org_profile.dart";
import "package:flutter/material.dart";
import "package:donation_app/screens/org/org_home.dart";
import "package:donation_app/screens/org/org_drives.dart";

class OrgMainPage extends StatefulWidget {
  const OrgMainPage({super.key});

  @override
  State<OrgMainPage> createState() => _OrgMainPageState();
}

class _OrgMainPageState extends State<OrgMainPage> {
  // implementation based on https://www.youtube.com/watch?v=xN5GhJ7QJjc
  int currentPage = 0;

  List<Widget> pages = [
    const OrgHomePage(),
    const OrgDrivesPage(),
    const OrgProfilePage(mode: 'view')
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
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ));
  }
}
