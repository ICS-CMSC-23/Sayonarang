import 'package:donation_app/screens/donor_new/donor_donation_form.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/models/user_model.dart' as user_model;

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  _DonorHomePageState createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  late User? _currentUser;
  Map<String, dynamic>? _userDetails;

  @override
  void initState() {
    super.initState();
    // execute initialization of the stream after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<DonationProvider>().fetchDonationsToOrg(_currentUser!.uid);
      context.read<MyAuthProvider>().fetchOpenOrgs();
    });
  }

  // TODO: Remove, move implementation to org profile page
  Future<void> _fetchUserDetails() async {
    final details =
        await context.read<MyAuthProvider>().getUserDetails(_currentUser!.uid);
    setState(() {
      _userDetails = details;
    });
  }

  Widget _buildOrgList(List<user_model.User> orgs) {
    if (orgs.isEmpty) {
      return const Center(
        child: Text(
          'No open organizations yet!',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: orgs.length,
      itemBuilder: (context, index) {
        user_model.User org = orgs[index];
        return _buildOrgCard(org);
      },
    );
  }

  Widget _buildOrgCard(user_model.User org) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          // change selected org
          context.read<MyAuthProvider>().changeSelectedOrg(org);

          // navigate to the create donation form page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DonorDonationFormPage(mode: 'add'),
            ),
          );
        },
        child: Card(
          surfaceTintColor: Colors.transparent,
          child: ListTile(
            title: Text(
              org.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // limit name to one line
            ),
            subtitle: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Click ",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ),
                  TextSpan(
                    text: " to know more",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // access donations in the provider
    Stream<QuerySnapshot> openOrgs = context.watch<MyAuthProvider>().openOrgs;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Organizations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: openOrgs,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No open organizations yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // convert data from donations stream to a list
          List<user_model.User> orgs = snapshot.data!.docs.map((doc) {
            user_model.User user =
                user_model.User.fromJson(doc.data() as Map<String, dynamic>);
            user.id = doc.id;
            return user;
          }).toList();

          return _buildOrgList(orgs);
        },
      ),
    );
  }
}
