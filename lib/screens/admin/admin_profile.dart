import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Color(0xFFF54741),
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Color(0xFFF54741)),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'ADMIN ACCOUNT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Divider(
              thickness: 2,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Section: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'CMSC 23 U-3L',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Members:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/caoile.jpg'),
              ),
              title: Text('Caoile, Ralph Philip Madera'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/domingo.jpg'),
              ),
              title: Text('Domingo, Reamonn Lois A'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/madrid.jpg'),
              ),
              title: Text('Madrid, Reinalyn A'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/silapan.jpg'),
              ),
              title: Text('Silapan, Francheska Marie A'),
            ),
          ],
        ),
      ),
    );
  }
}
