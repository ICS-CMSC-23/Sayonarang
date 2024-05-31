import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/models/donor_profile_model.dart';
import 'package:donation_app/providers/donor_provider.dart';
import 'package:donation_app/screens/donor/donor_profileheader.dart';
import 'package:donation_app/providers/user_provider.dart';

class DonorProfileWidget extends StatefulWidget {
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
      _userDocFuture = Provider.of<DonorProvider>(context, listen: false)
          .getUserById(_currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _currentUser == null
            ? Center(child: Text('No user is currently signed in'))
            : FutureBuilder<DocumentSnapshot>(
                future: _userDocFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('User not found'));
                  } else {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final donorProfile = DonorProfileModel.fromMap(userData);

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          ProfileHeader(
                            donorName: donorProfile.name,
                            username: donorProfile.username,
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<MyAuthProvider>().signOut();
                              },
                              child: Text('Logout'),
                            ),
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
