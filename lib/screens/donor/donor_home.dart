import 'package:donation_app/providers/donor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'donor_donate.dart';
import 'donor_organizations.dart';
import 'donor_profile.dart';
import 'package:flutter/cupertino.dart';

class DonorView extends StatelessWidget {
  const DonorView({super.key});

  static const List<String> _pageTitles = [
    'Organizations',
    'Donate Now',
    'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DonorProvider>(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Organizations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Donate Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
            label: 'Profile',
          ),
        ],
        currentIndex: provider.selectedIndex,
        onTap: (index) => provider.updateIndex(index),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return Scaffold(
              appBar: CupertinoNavigationBar(
                middle: Text(_pageTitles[index]),
              ),
              body: _DonorPages[index],
            );
          },
        );
      },
    );
  }

  static List<Widget> _DonorPages = <Widget>[
    ViewOrganizations(),
    DonorDonatePage(),
    DonorProfileWidget(),
  ];
}
