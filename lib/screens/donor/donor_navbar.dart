import 'package:flutter/material.dart';

class DonorBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  DonorBottomNavigationBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, "/donor/home");
            break;
          case 1:
            Navigator.pushNamed(context, "/donor/donate");
            break;
          case 2:
            Navigator.pushNamed(context, "/donor/profile");
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
          label: 'Donate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
