import 'package:dhaba/pages/user/classes_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _reenterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _reenterPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Re-enter New Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Implement logic to change password
                await _savePassword();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String reenteredPassword = _reenterPasswordController.text;

    if (newPassword != reenteredPassword) {
      _showErrorDialog('New passwords do not match');
      return;
    }

    // Make a network request to change the password
    const String changePasswordUrl =
        'http://localhost:3000/api/changePassword/student'; // Update the URL

    try {
      final response = await http.post(
        Uri.parse(changePasswordUrl),
        body: jsonEncode({
          'ID': currentUser.studentId, // Assuming currentVendor is accessible
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _clearPasswordFields();
        final snackBar = SnackBar(
          content: Text('Password changed successfully!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData['error'];

        _showErrorDialog('Password change failed: $errorMessage');
      }
    } catch (e) {
      // Handle network errors
      _showErrorDialog('Password change failed: Network error.');
    }
  }

  void _clearPasswordFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _reenterPasswordController.clear();
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
}
