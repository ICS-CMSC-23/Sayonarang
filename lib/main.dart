import 'package:flutter/material.dart';
import './screens/login_page.dart';
import './screens/signup_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Donation Application',
    theme: ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 62, 0, 150)),
      useMaterial3: true,
    ),
    initialRoute: '/',
    routes: {
      // set the routes of the pages
      '/': (context) => const LoginPage(),
      '/signup': (context) => const SignupPage(),
    },
  ));
}
