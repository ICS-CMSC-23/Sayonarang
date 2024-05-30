import "package:donation_app/models/donation_model.dart";
import "package:donation_app/providers/donation_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class OrgDonationDetailsPage extends StatefulWidget {
  const OrgDonationDetailsPage({super.key});

  @override
  State<OrgDonationDetailsPage> createState() => _OrgDonationDetailsPageState();
}

class _OrgDonationDetailsPageState extends State<OrgDonationDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Donation selectedDonation = context.read<DonationProvider>().selected;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Donation Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      )),
      body: Text("${selectedDonation.id}"),
    );
  }
}
