import 'package:flutter/material.dart';
import 'package:donation_app/screens/donor_new/donor_dimensions.dart';

class ProfileHeader extends StatelessWidget {
  final String donorName;
  final String username;
  final String contactNum;
  final List<String> addresses;

  const ProfileHeader({
    super.key,
    required this.donorName,
    required this.username,
    required this.contactNum,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.containerWidth,
      height: Dimensions.containerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(255, 245, 243, 243),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color.fromRGBO(245, 71, 65, 1),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donorName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Number:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              contactNum,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Addresses:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            ...addresses.map((address) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                address,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
