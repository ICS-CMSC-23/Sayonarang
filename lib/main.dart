import 'package:flutter/material.dart';
import './screens/login_page.dart';
import './screens/signup_page.dart';
import 'package:donation_app/screens/org/org_donation_drives.dart';
import 'package:donation_app/screens/org/org_home.dart';
import 'package:donation_app/screens/org/org_profile.dart';


void main() {
  runApp(MaterialApp(
    title: 'Donation Application',
    theme: ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 62, 0, 150)),
      useMaterial3: true,
    ),
    initialRoute: '/org/home',
    routes: {
      // set the routes of the pages
      '/': (context) => const LoginPage(),
      '/signup': (context) => const SignupPage(),
      '/org/home': (context) => const OrgHomePage(),
      '/org/profile': (context) => const OrgProfilePage(),
      '/org/drives': (context) => const OrgDonationDrivesPage(),

    },
  ));
}
