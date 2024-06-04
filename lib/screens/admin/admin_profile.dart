import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ADMIN ACCOUNT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(height: 20),
            const Row(
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
            const SizedBox(height: 20),
            const Text(
              'Members:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/caoile.jpg'),
              ),
              title: Text('Caoile, Ralph Philip Madera'),
            ),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/domingo.jpg'),
              ),
              title: Text('Domingo, Reamonn Lois A'),
            ),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/madrid.jpg'),
              ),
              title: Text('Madrid, Reinalyn A'),
            ),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/silapan.jpg'),
              ),
              title: Text('Silapan, Francheska Marie A'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<MyAuthProvider>().signOut();
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
