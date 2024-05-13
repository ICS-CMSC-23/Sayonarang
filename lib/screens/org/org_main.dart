import "package:donation_app/screens/org/org_home.dart";
import "package:flutter/material.dart";

class OrgMainPage extends StatefulWidget {
  const OrgMainPage({super.key});

  @override
  State<OrgMainPage> createState() => _OrgMainPageState();
}

class _OrgMainPageState extends State<OrgMainPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
