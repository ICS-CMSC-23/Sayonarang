import "package:donation_app/models/donation_model.dart";
import "package:donation_app/providers/donation_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DonationDetailsPage extends StatefulWidget {
  const DonationDetailsPage({super.key});

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
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
