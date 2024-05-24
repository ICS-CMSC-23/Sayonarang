import "package:donation_app/models/donation_model.dart";
import "package:donation_app/providers/donation_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DriveFormPage extends StatefulWidget {
  const DriveFormPage({super.key});

  @override
  State<DriveFormPage> createState() => DriveFormPageState();
}

class DriveFormPageState extends State<DriveFormPage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Donation selectedDonation = context.read<DonationProvider>().selected;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Create Donation Drive",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      )),
      body: Text(""),
    );
  }
}
