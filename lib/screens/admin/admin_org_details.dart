import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'admin_org_account_details.dart';
import 'admin_org_donations_list.dart';

class OrganizationDetailsView extends StatefulWidget {
  final User org;

  const OrganizationDetailsView({Key? key, required this.org})
      : super(key: key);

  @override
  State<OrganizationDetailsView> createState() =>
      _OrganizationDetailsViewState();
}

class _OrganizationDetailsViewState extends State<OrganizationDetailsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.org.name),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Donation Drives'),
              Tab(text: 'Account Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrgDonationsList(orgId: widget.org.id!),
            OrgAccountDetails(org: widget.org),
          ],
        ),
      ),
    );
  }
}
