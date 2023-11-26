import 'package:flutter/material.dart';
import 'package:dhaba/pages/vendor/set_details.dart';
import 'package:dhaba/pages/vendor/set_menu.dart';
import 'package:dhaba/pages/vendor/view_orders.dart';

class VendorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Set Details page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SetDetailsPage(),
                ));
              },
              child: Text('Set Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Set Menu page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SetMenuPage(),
                ));
              },
              child: Text('Set Menu'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to View Orders page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewOrdersPage(),
                ));
              },
              child: Text('View Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
