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
      padding: const EdgeInsets.all(Dimensions.padding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(height: Dimensions.spacing * 2),
          Text(
            donorName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: Dimensions.spacing),
          const Text(
            'Username:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: Dimensions.spacing / 2),
          Text(
            username,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.spacing * 2),
          const Text(
            'Contact Number:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: Dimensions.spacing / 2),
          Text(
            contactNum,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: Dimensions.spacing * 2),
          const Text(
            'Addresses:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: Dimensions.spacing / 2),
          ...addresses.map((address) => Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.spacing),
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
    );
  }
}
