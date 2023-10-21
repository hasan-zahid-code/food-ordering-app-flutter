// lib/pages/registration_page.dart

import 'package:dhaba/lib/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailValidationMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/bg-1.jpg'), // Replace with your background image
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.transparent, // Set background color to transparent
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/FAST.png', // Replace with the path to your logo
                width: 100, // Adjust the width as needed
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (kxxxxxx@nu.edu.pk)',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: _emailValidationMessage,
                ),
                onChanged: (email) {
                  setState(() {
                    _emailValidationMessage =
                        _validateEmail(email) ? null : 'Invalid email format';
                  });
                },
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password (8 characters)',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement registration logic here
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    // Use a regular expression to validate the email format
    final RegExp emailRegExp =
        RegExp(r'^k\d{6}@nu.edu.pk$', caseSensitive: false);
    return emailRegExp.hasMatch(email);
  }
}
