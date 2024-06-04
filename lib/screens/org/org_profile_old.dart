import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';

class OrgProfilePageOld extends StatefulWidget {
  const OrgProfilePageOld({super.key});
  @override
  _OrgProfilePageOldState createState() => _OrgProfilePageOldState();
}

class _OrgProfilePageOldState extends State<OrgProfilePageOld> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // child: Text("Org Profile"),
        child: Center(
            child: ElevatedButton(
                onPressed: () {
                  context.read<MyAuthProvider>().signOut();
                },
                child: const Text("Logout"))));
  }
}
