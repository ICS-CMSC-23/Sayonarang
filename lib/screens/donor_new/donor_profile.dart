import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';

class DonorProfilePage extends StatefulWidget {
  const DonorProfilePage({super.key});
  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
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
