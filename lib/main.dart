import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './screens/login_page.dart';
import './screens/signup_page.dart';
import 'package:donation_app/screens/org/org_donation_drives.dart';
import 'package:donation_app/screens/org/org_home.dart';
import 'package:donation_app/screens/org/org_profile.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'Donation Application',
//     theme: ThemeData(
//       colorScheme:
//           ColorScheme.fromSeed(seedColor: Color.fromARGB(1, 231, 35, 38)),
//       brightness: Brightness.light,
//       primaryColor: Color.fromARGB(1, 231, 35, 38),
//       useMaterial3: true,
//     ),
//     initialRoute: '/org/home',
//     routes: {
//       // set the routes of the pages
//       '/': (context) => const LoginPage(),
//       '/signup': (context) => const SignupPage(),
//       '/org/home': (context) => const OrgHomePage(),
//       '/org/profile': (context) => const OrgProfilePage(),
//       '/org/drives': (context) => const OrgDonationDrivesPage(),
//     },
//   ));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      // MultiProvider(
      //   providers: [
      //     // ChangeNotifierProvider(create: ((context) => DonationProvider())),
      //     // ChangeNotifierProvider(create: ((context) => DonationDriveProvider())),
      //     // ChangeNotifierProvider(create: ((context) => UserProvider())),
      //     // ChangeNotifierProvider(create: ((context) => MyAuthProvider())),
      //   ],
      //   child: MyApp(),
      // ),
      MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // https://stackoverflow.com/a/62989332
  final ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(231, 35, 28, 1),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromRGBO(255, 255, 255, 1),
    onSecondary: Color.fromRGBO(21, 26, 38, 1),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    background: Color.fromRGBO(250, 250, 250, 1), // Eggshell white
    onBackground: Color.fromRGBO(21, 26, 38, 1),
    surface: Color.fromRGBO(255, 255, 255, 1),
    onSurface: Color.fromRGBO(21, 26, 38, 1),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation Application',
      theme: ThemeData(
        colorScheme: colorScheme,
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
    );
  }
}
