import 'package:flutter/material.dart';
import 'package:donation_app/screens/org/org_navbar.dart';

class OrgProfilePage extends StatefulWidget {
  const OrgProfilePage({super.key});
  @override
  _OrgProfilePageState createState() => _OrgProfilePageState();
}

class _OrgProfilePageState extends State<OrgProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Text("Org Profile"),
    );
  }
}
