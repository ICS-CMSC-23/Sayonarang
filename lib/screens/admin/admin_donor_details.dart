import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_donor_donations_list.dart';
import 'admin_user_account_details.dart';

class DonorDetailsView extends StatefulWidget {
  final User donor;

  const DonorDetailsView({Key? key, required this.donor}) : super(key: key);

  @override
  State<DonorDetailsView> createState() => _DonorDetailsViewState();
}

class _DonorDetailsViewState extends State<DonorDetailsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.donor.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Donations'),
              Tab(text: 'Account Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DonorDonationsList(donorId: widget.donor.id!),
            UserAccountDetails(user: widget.donor),
          ],
        ),
      ),
    );
  }
}
