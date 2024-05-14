import "package:flutter/material.dart";
import "package:donation_app/screens/donor/donor_donate.dart";
import "package:donation_app/screens/donor/donor_profile.dart";
import "package:donation_app/screens/donor/donor_home.dart";


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: DonorMainPage(),
    );
  }
}

// class DonorMainPage extends StatefulWidget {
//   @override
//   _DonorMainPageState createState() => _DonorMainPageState();
// }

// class _DonorMainPageState extends State<DonorMainPage> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     DonorHomePage(),
//     DonorDonatePage(),
//     DonorProfileWidget(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.monetization_on),
//             label: 'Donate',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }



class DonorMainPage extends StatefulWidget {
  const DonorMainPage({super.key});

  @override
  State<DonorMainPage> createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  int currentPage = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      DonorHomePage(onPageChange: _changePage),
      const DonorDonatePage(),
      DonorProfileWidget(),
    ];
  }

  void _changePage(int index) {
    setState(() {
      currentPage = index;
    });
  }

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
            ),
          ],
        ));
  }
}
