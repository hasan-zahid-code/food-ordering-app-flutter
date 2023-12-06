import 'package:dhaba/pages/vendor/vendorDashboard.dart';
import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/login_page.dart';
import 'package:dhaba/pages/user/vendor_list_page.dart';
import 'package:dhaba/pages/vendor/vendor_login_page.dart';
import 'package:dhaba/pages/vendor/classes_data.dart'; // Import your classes_data.dart file
import 'package:dhaba/pages/vendor/view_orders.dart';
import 'package:provider/provider.dart'; // Import the provider package

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VendorListPage(),
    );
  }
}

class HeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/bg-1.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/FAST.png', // Replace with the path to your logo
                  width: 200, // Adjust the width as needed
                ),
                SizedBox(height: 20),
                Text(
                  'DHAABA 2.0',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the vendor login page
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VendorLoginPage(),
                    ));
                  },
                  child: Text('Login as Vendor'),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the student login page
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  },
                  child: Text('Login as Student'),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
