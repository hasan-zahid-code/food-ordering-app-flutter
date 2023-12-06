import 'package:dhaba/main.dart';
import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/profile_settings_page.dart';
import 'package:dhaba/pages/user/about_developers_page.dart';
import 'package:dhaba/pages/user/classes_data.dart';

// Define the Drawer globally
Drawer globalDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage('Fast.jpg'), // Replace with your image path
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'DHAABA 2.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Hello, ${currentUser.userName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('Change Password'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileSettingsPage(),
            ));
          },
        ),
        ListTile(
          title: Text('About Developers'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AboutDevelopersPage(),
            ));
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            currentUser.clear();
            cartItemsMap.clear();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HeroPage(),
                ),
                (route) => false);
          },
        ),
      ],
    ),
  );
}
