import 'package:flutter/material.dart';
import 'package:donation_app/screens/donor_new/donor_dimensions.dart';

class ProfileHeader extends StatelessWidget {
  final String donorName;
  final String username;

  const ProfileHeader({
    super.key,
    required this.donorName,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.containerWidth,
      height: Dimensions.containerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(Dimensions.padding),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/placeholder.jpg'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                donorName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 22),
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
        ],
      ),
    );
  }
}
