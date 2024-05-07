import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        title: const Text('App Name'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 52, bottom: 16, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  textField('Username', _usernameController),
                  textField('Password', _passwordController),

                  // log in button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/');
                      },
                      child: const Text('Log In'),
                    ),
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign Up',
                        ))
                  ]),
                ],
              ),
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
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.purple),
        ),
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      controller: textController,
    ),
  );
}
