import 'package:dhaba/lib/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String? _passwordValidationMessage;
  String? _passwordMatchMessage;

  Future<void> _registerUser() async {
    final String url = 'http://localhost:3000/api/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'Username': _usernameController.text,
          'Email': _emailController.text,
          'Password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final successMessage = jsonData['message'];

        final snackBar = SnackBar(
          content: Text(successMessage),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData['error'];

        final snackBar = SnackBar(
          content: Text('Registration failed: $errorMessage'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
            'Registration failed: Network error. Please check your internet connection.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg-1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/FAST.png',
                      width: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'DHAABA 2.0',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                onChanged: (password) {
                  setState(() {
                    _passwordValidationMessage = (password.length >= 8)
                        ? null
                        : 'Password Less Than 8 Characters';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Password (8 characters)',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: _passwordValidationMessage,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (confirmPassword) {
                  if (confirmPassword == _passwordController.text) {
                    setState(() {
                      _passwordMatchMessage =
                          null; // Passwords match, clear the error message
                    });
                  } else {
                    setState(() {
                      _passwordMatchMessage = 'Passwords don\'t match';
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: _passwordMatchMessage,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(120, 40)), // Adjust button size
                  ),
                  onPressed: () {
                    _registerUser();
                  },
                  child: Text('Register'),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(120, 40)), // Adjust button size
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    final RegExp emailRegExp =
        RegExp(r'^k\d{6}@nu.edu.pk$', caseSensitive: false);
    return emailRegExp.hasMatch(email);
  }
}
