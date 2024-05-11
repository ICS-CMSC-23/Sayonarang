import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  late TabController tabController;

  // text controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  Widget signupButton() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // Navigator.pushNamed(context, '/');
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Already have an account?'),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Log In',
              ))
        ]),
      ],
    );
  }

  Widget signUpDonor() {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            textField('Name', _nameController),
            textField('Username', _usernameController),
            textField('Password', _passwordController),
            textField('Address', _addressController),
            textField('Contact Number', _contactNumController),
            const SizedBox(height: 20), // spacing purposes
            signupButton(),
          ],
        ));
  }

  Widget signUpOrganization() {
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            textField('Name', _nameController),
            textField('Username', _usernameController),
            textField('Password', _passwordController),
            textField('Address', _addressController),
            textField('Contact Number', _contactNumController),

            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Proof of Legitimacy',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            // upload a file for proof of legitimacy
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: TextButton(
                onPressed: () {
                  // TODO: display filename
                },
                child: const Text('Upload a File'),
              ),
            ),

            signupButton(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: MediaQuery.of(context).size.height * 0.05,
        automaticallyImplyLeading: false, // remove back button
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 10, left: 16, right: 16),
              child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const Text('Create an Account',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20), // spacing purposes

                    // container for tab bar
                    Container(
                      child: TabBar(controller: tabController, tabs: const [
                        Tab(text: 'As a Donor'),
                        Tab(text: 'As an Organization'),
                      ]),
                    ),

                    // container for contents of tab bar
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: TabBarView(
                        controller: tabController,
                        children: [signUpDonor(), signUpOrganization()],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

Widget textField(String label, TextEditingController textController) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: TextField(
      decoration: InputDecoration(
        // focusedBorder: const UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.purple),
        // ),
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      controller: textController,
    ),
  );
}
