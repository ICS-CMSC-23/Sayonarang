import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_donor_donations_list.dart';
import 'admin_org_donations_list.dart';
import 'admin_user_account_details.dart';

class UserDetailsView extends StatefulWidget {
  final User user;

  const UserDetailsView({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          bottom: TabBar(
            tabs: [
              widget.user.role == 'org'
                  ? Tab(text: 'Donation Drives')
                  : Tab(text: 'Donations'),
              Tab(text: 'Account Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            widget.user.role == 'org'
                ? OrgDonationsList(orgId: widget.user.id!)
                : DonorDonationsList(donorId: widget.user.id!),
            UserAccountDetails(user: widget.user),
          ],
        ),
      ),
    );
  }
}
