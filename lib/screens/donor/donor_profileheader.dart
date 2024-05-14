import 'package:flutter/material.dart';
import 'donor_dimensions.dart';

class ProfileHeader extends StatelessWidget {
  final String donorName;
  final String username;

  ProfileHeader({
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
          Padding(
            padding: EdgeInsets.all(Dimensions.padding),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://picsum.photos/seed/216/600'),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                donorName,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                username,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
