import 'package:dhaba/main.dart';
import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/profile_settings_page.dart';
import 'package:dhaba/pages/user/wallet_page.dart';
import 'package:dhaba/pages/user/about_developers_page.dart';

// Define the Drawer globally
Drawer globalDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'DHAABA 2.0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
            ),
          ),
        ),
        ListTile(
          title: Text('Profile Settings'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileSettingsPage(),
            ));
            // Handle menu item 1 tap here
          },
        ),
        ListTile(
          title: Text('Wallet'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WalletPage(
                userName:
                    'Abdullah Siddiqui', // Pass the user's name dynamically
                userEmail:
                    'k213447@nu.edu.pk', // Pass the user's email dynamically
                walletAmount: 1000.0, // Pass the wallet amount dynamically
              ),
            ));
            // Handle menu item 2 tap here
          },
        ),
        ListTile(
          title: Text('About Developers'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AboutDevelopersPage(),
              // Handle menu item 2 tap here
            ));
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            // Navigate to the vendor login page
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HeroPage(),
            ));
          },
        ),
      ],
    ),
  );
}
