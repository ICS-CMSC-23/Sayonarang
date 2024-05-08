import 'package:flutter/material.dart';

class OrgBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  OrgBottomNavigationBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, "/org/home");
            break;
          case 1:
            Navigator.pushNamed(context, "/org/drives");
            break;
          case 2:
            Navigator.pushNamed(context, "/org/profile");
            break;
        }
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
        ),
      ],
    );
  }
}
