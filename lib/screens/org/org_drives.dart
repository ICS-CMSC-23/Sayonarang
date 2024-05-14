import 'package:flutter/material.dart';

class OrgDrivesPage extends StatefulWidget {
  const OrgDrivesPage({super.key});
  @override
  _OrgDrivesPageState createState() => _OrgDrivesPageState();
}

class _OrgDrivesPageState extends State<OrgDrivesPage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Text("Org Donation Drives"),
    );
  }
}
