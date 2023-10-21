import 'package:flutter/material.dart';
import 'package:dhaba/lib/pages/favorites_page.dart'; // Import the FavoritesPage
import 'package:dhaba/lib/pages/menu_page.dart';
import 'package:dhaba/lib/pages/cart_page.dart'; // Import the CartPage
import 'package:dhaba/lib/pages/drawer.dart';
import 'package:dhaba/lib/pages/classes_data.dart';

class VendorListPage extends StatefulWidget {
  @override
  _VendorListPageState createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  int _selectedIndex = 0; // Index of the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 // Show the app bar on the "Food Vendors" page
          ? AppBar(
              title: Text('Food Vendors'),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : null, // Set to null to hide the app bar
      drawer: globalDrawer(context), // Use the globalDrawer function
      body: _buildBody(), // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Color for selected tab
        unselectedItemColor: Colors.grey, // Color for unselected tabs
        onTap: _onTabTapped,
      ),
    );
  }

  // Helper method to build the body content
  Widget _buildBody() {
    if (_selectedIndex == 0) {
      // Display the VendorList page
      return VendorList();
    } else if (_selectedIndex == 1) {
      // Display the CartPage when Cart tab is selected
      return CartPage(
        cartItems: cartItemsMap.values.toList(),
        showBackButton: false,
      );
    } else if (_selectedIndex == 2) {
      // Display the FavoritesPage when Favorites tab is selected
      return FavoritesPage(favoriteItems: User(favorites: favoriteItems));
    }

    return Container(); // Return an empty container if index is out of range
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class VendorList extends StatelessWidget {
  // Define your list of food vendors here

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];

          return Card(
            margin: EdgeInsets.all(12.0),
            color: vendor.cardColor,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MenuPage(vendor: vendor),
                ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vendor.icon,
                    size: 80.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    vendor.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Location: ${vendor.location}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Description: ${vendor.description}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}