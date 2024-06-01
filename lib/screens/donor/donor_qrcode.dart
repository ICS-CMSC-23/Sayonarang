import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final String donationId;

  const QrCodeScreen({Key? key, required this.donationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFF54741),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF54741)),
      ),
      body: Center(
        child: Theme(
          data: ThemeData( // Custom theme data
            // Define the theme for the QR code
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Color of the QR code
              onPrimary: Colors.white, // Color of the text in the QR code
            ),
            // Apply the custom text theme
            textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.black), // Text color
            ),
          ),
          child: QrImageView(
            data: donationId,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}

