import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_donor_account_details.dart';
import 'admin_donor_donations_list.dart';

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
          title: Text('Donor Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Donations'),
              Tab(text: 'Account Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DonorDonationsList(donorId: widget.donor.id!),
            DonorAccountDetails(donor: widget.donor),
          ],
        ),
      ),
    );
  }
}
