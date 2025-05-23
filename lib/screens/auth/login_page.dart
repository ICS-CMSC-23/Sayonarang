import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donation_app/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty) {
        setState(() {
          isEmailValid = true;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordController.text.isNotEmpty) {
        setState(() {
          isPasswordValid = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget textField(String label, TextEditingController textController,
      bool isPassword, bool isValid, String errorMessage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          labelText: label,
          errorText: isValid ? null : errorMessage,
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
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.30,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: MediaQuery.of(context).size.height * 0.40,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            child: Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 16, right: 16, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    textField('Email', _emailController, false, isEmailValid,
                        'Email is required'),

                    textField('Password', _passwordController, true,
                        isPasswordValid, 'Password is required'),

                    // log in button
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          setState(() {
                            isEmailValid = _emailController.text.isNotEmpty;
                            isPasswordValid =
                                _passwordController.text.isNotEmpty;
                          });

                          final myAuthProvider = context.read<MyAuthProvider>();

                          if (isEmailValid && isPasswordValid) {
                            await myAuthProvider.signIn(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            // check if log in is not successful
                            if (!myAuthProvider.userDetails['success']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${myAuthProvider.userDetails['response']}'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Log In',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
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
      ),
    );
  }
}
