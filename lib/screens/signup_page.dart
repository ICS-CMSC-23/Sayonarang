import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumController = TextEditingController();
  bool _obscureText = true;

  List<Widget> addressFields = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _contactNumController.dispose();
    super.dispose();
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
            onPressed: () async {
              // Navigator.pushNamed(context, '/');
              // TODO: add validation

              await context.read<MyAuthProvider>().signUp(
                  _nameController.text,
                  _usernameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _contactNumController.text,
                  // addressFields
                  //     .map((e) => (e as Row).children[0] as TextField)
                  //     .map((e) => e.controller!.text)
                  //     .toList(),
                  _addressController.text,
                  '',
                  tabController.index == 0 ? 'donor' : 'org');
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
            textField('Name', _nameController, false),
            textField('Username', _usernameController, false),
            textField('Email', _emailController, false),
            textField('Password', _passwordController, true),
            textField('Contact Number', _contactNumController, false),
            textField('Address', _addressController, false),
            ...addressFields,
            TextButton(
              onPressed: () {
                setState(() {
                  addressFields.add(
                    Row(
                      children: [
                        Expanded(
                            child: textField(
                                'Address', TextEditingController(), false)),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              addressFields.removeLast();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text('Add Address'),
                ],
              ),
            ),

            const SizedBox(height: 10), // spacing purposes
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
            textField('Name of Organization', _nameController, false),
            textField('Username', _usernameController, false),
            textField('Email', _emailController, false),
            textField('Password', _passwordController, true),
            textField('Contact Number', _contactNumController, false),
            textField('Address', _addressController, false),
            ...addressFields,
            TextButton(
              onPressed: () {
                setState(() {
                  addressFields.add(
                    Row(
                      children: [
                        Expanded(
                            child: textField(
                                'Address', TextEditingController(), false)),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              addressFields.removeLast();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text('Add Address'),
                ],
              ),
            ),

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

  Widget textField(
      String label, TextEditingController textController, bool isPassword) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        controller: textController,
      ),
    );
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
