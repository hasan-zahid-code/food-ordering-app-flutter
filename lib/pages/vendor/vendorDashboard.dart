import 'package:flutter/material.dart';
import 'package:dhaba/pages/vendor/set_details.dart';
import 'package:dhaba/pages/vendor/vendor_menu_page.dart';
import 'package:dhaba/pages/vendor/view_orders.dart';
import 'package:dhaba/main.dart'; // Import the HeroPage

class VendorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardButton(
              onPressed: () {
                // Navigate to Set Details page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SetDetailsPage(),
                ));
              },
              title: 'Set Details',
              color: Colors.blue,
              icon: Icons.settings,
            ),
            SizedBox(height: 20),
            CardButton(
              onPressed: () {
                // Navigate to VendorMenuWidget
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VendorMenuPage(),
                ));
              },
              title: 'Vendor Menu',
              color: Colors.green,
              icon: Icons.restaurant_menu,
            ),
            SizedBox(height: 20),
            CardButton(
              onPressed: () {
                // Navigate to View Orders page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewOrdersPage(),
                ));
              },
              title: 'View Orders',
              color: Colors.orange,
              icon: Icons.list,
            ),
            SizedBox(height: 20),
            CardButton(
              onPressed: () {
                // Navigate to HeroPage on logout
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HeroPage(),
                  ),
                  (route) => false,
                );
              },
              title: 'Logout',
              color: Colors.redAccent,
              icon: Icons.power_settings_new,
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color color;
  final IconData icon;

  const CardButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
