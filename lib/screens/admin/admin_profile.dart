import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ADMIN ACCOUNT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Section: CMSC 23 U-3L'),
            SizedBox(height: 8),
            Text('Members:'),
            Text('CAOILE, RALPH PHILIP MADERA'),
            Text('DOMINGO, REAMONN LOIS ATIBAGOS'),
            Text('MADRID, REINALYN ANDAL'),
            Text('SILAPAN, FRANCHESKA MARIE ALIPIO'),
          ],
        ),
      ),
    );
  }
}
