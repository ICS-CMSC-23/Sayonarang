import "package:flutter/material.dart";
import "package:donation_app/screens/org/org_home.dart";
import "package:donation_app/screens/org/org_drives.dart";
import "package:donation_app/screens/org/org_profile.dart";

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';
import 'package:donation_app/screens/auth/login_page.dart';

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
    const OrgProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<MyAuthProvider>().userStream;

    userStream.listen((User? user) {
      if (user != null) {
        print('User ID: ${user.uid}');
      } else {
        print('No user');
      }
    });

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error encountered: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            print('No user data');
            return const LoginPage();
          }

          print('User data found');
          return displayPage(context);
        });
  }

  Scaffold displayPage(BuildContext context) {
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
