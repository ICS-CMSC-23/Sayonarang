import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/models/donor_profile_model.dart';
import 'package:donation_app/providers/donor_provider.dart';
import 'package:donation_app/screens/donor/donor_profileheader.dart'; 
import 'package:donation_app/screens/donor/donor_navbar.dart'; 
import 'package:donation_app/screens/auth/login_page.dart'; 

class DonorProfileWidget extends StatefulWidget {
  @override
  _DonorProfileWidgetState createState() => _DonorProfileWidgetState();
}

class _DonorProfileWidgetState extends State<DonorProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Use a StreamBuilder to listen to changes in donor profile data
            StreamBuilder<DonorProfileModel?>(
              stream: Provider.of<DonorProfileProvider>(context).donorProfileStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final donorProfile = snapshot.data;
                  return Column(
                    children: [
                      // Display the ProfileHeader widget
                      ProfileHeader(
                        donorName: donorProfile?.name ?? "[Donor Name]",
                        username: donorProfile?.username ?? "username",
                      ),
                      // Add other widgets to display donor profile data
                      // Centered Logout Button
                      SizedBox(height: 20), // Add some spacing
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add logout functionality here
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text('Logout'),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            // ... other widgets ...
          ],
        ),
      ),
 // Add the bottom navigation bar
    );
  }
}

