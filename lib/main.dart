import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Donation Application',
    theme: ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 62, 0, 150)),
      useMaterial3: true,
    ),
    initialRoute: '/',
    routes: {
      // set the routes of the pages
      '/': (context) => const TemporaryPage(),
    },
  ));
}

class TemporaryPage extends StatelessWidget {
  const TemporaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Application'),
      ),
      body: Text('This is a temporary page'),
    );
  }
}
