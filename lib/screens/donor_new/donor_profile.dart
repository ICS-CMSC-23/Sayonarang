import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/models/donor_profile_model.dart';
import 'package:donation_app/screens/donor_new/donor_profileheader.dart';
import 'package:donation_app/providers/user_provider.dart';

class DonorProfileWidget extends StatefulWidget {
  const DonorProfileWidget({super.key});

  @override
  _DonorProfileWidgetState createState() => _DonorProfileWidgetState();
}

class _DonorProfileWidgetState extends State<DonorProfileWidget> {
  late User? _currentUser;
  late Future<DocumentSnapshot> _userDocFuture;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _userDocFuture = Provider.of<MyAuthProvider>(context, listen: false)
          .getUserById(_currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentUser == null
            ? const Center(child: Text('No user is currently signed in'))
            : FutureBuilder<DocumentSnapshot>(
                future: _userDocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('User not found'));
                  } else {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final donorProfile = DonorProfileModel.fromMap(userData);

                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 25),
                          ProfileHeader(
                            donorName: donorProfile.name,
                            username: donorProfile.username,
                            contactNum: donorProfile.contactNum,
                            addresses: donorProfile.addresses,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<MyAuthProvider>().signOut();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
