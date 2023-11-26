import 'package:dhaba/pages/vendor/classes_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SetDetailsPage extends StatefulWidget {
  @override
  _SetDetailsPageState createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = currentVendor.name;
    _descriptionController.text = currentVendor.description;
    _contactNumberController.text = currentVendor.contactNo;
    _emailController.text = currentVendor.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: currentVendor.vendorid,
              enabled: false,
              decoration: InputDecoration(labelText: "Vendor ID"),
            ),
            _buildTextField("Vendor Name", _nameController),
            _buildTextField("Description", _descriptionController),
            _buildTextField("Contact Number", _contactNumberController),
            _buildTextField("Email", _emailController),
            //  Spacer(), // Spacer to push the buttons to the bottom
            _isEditing
                ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _savePermanently();
                        },
                        child: Text('Save Permanently'),
                      ),
                    ],
                  )
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _startEditing,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _savePermanently() async {
    currentVendor.name = _nameController.text;
    currentVendor.description = _descriptionController.text;
    currentVendor.contactNo = _contactNumberController.text;
    currentVendor.email = _emailController.text;

    if (_validateInputs()) {
      const String url = 'http://localhost:3000/api/setDetails';

      try {
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode({
            'VendorId': currentVendor.vendorid,
            'Name': currentVendor.name,
            'Description': currentVendor.description,
            'Phone': currentVendor.contactNo,
            'Email': currentVendor.email,
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
            content: Text('Vendor Data Update failed: $errorMessage'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: Text('Updation failed: Network error.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    // After saving permanently, disable editing mode
    setState(() {
      _isEditing = false;
    });
  }

  bool _validateInputs() {
    if (currentVendor.email.isEmpty || !_validateEmail(currentVendor.email)) {
      _showErrorDialog('Invalid Email');
      return false;
    } else if (currentVendor.contactNo.isEmpty) {
      _showErrorDialog('Contact number cannot be empty');
      return false;
    } else if (currentVendor.name.isEmpty) {
      _showErrorDialog('Name cannot be empty');
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
    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }
}
