import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorRegistrationPage extends StatefulWidget {
  @override
  _VendorRegistrationPageState createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailValidationMessage;
  String? _passwordValidationMessage;
  String? _passwordMatchMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Registration'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone# (03XXXXXXXXX)',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                          : 'Password must be at least 8 characters';
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
                        _passwordMatchMessage = null;
                      });
                    } else {
                      setState(() {
                        _passwordMatchMessage = 'Passwords do not match';
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
                ElevatedButton(
                  onPressed: _registerVendor,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerVendor() async {
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (_validateInputs(email, phone, password, confirmPassword)) {
      const String url = 'http://localhost:3000/api/vendorRegister';

      try {
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            'Phone': _phoneController.text,
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
  }

  bool _validateInputs(
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) {
    if (email.isEmpty || !_validateEmail(email)) {
      _showErrorDialog('Invalid Email');
      return false;
    } else if (phone.isEmpty) {
      _showErrorDialog('Phone number cannot be empty');
      return false;
    } else if (password.isEmpty || password.length < 8) {
      _showErrorDialog('Password must be at least 8 characters');
      return false;
    } else if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _validateEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}
