import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/favorites_page.dart'; // Import the FavoritesPage
import 'package:dhaba/pages/user/menu_page.dart';
import 'package:dhaba/pages/user/cart_page.dart'; // Import the CartPage
import 'package:dhaba/pages/user/drawer.dart';
import 'package:dhaba/pages/user/classes_data.dart';

Future<List<FoodVendor>> populateVendors() async {
  return await fetchVendors();
}

class VendorListPage extends StatefulWidget {
  @override
  _VendorListPageState createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  int _selectedIndex = 0;

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
      return VendorList();
    } else if (_selectedIndex == 1) {
      // Display the CartPage when Cart tab is selected
      return CartPage(
        cartItems: cartItemsMap.values.toList(),
        showBackButton: false,
      );
    } else if (_selectedIndex == 2) {
      // Display the FavoritesPage when Favorites tab is selected
      return FavoritesPage(
          favoriteItems: User(favorites: currentUser.favorites));
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<FoodVendor>>(
        future: populateVendors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final vendors = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
              ),
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];

                return Card(
                  margin: EdgeInsets.all(10),
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
            );
          }
          return Text('No data to display.');
        },
      ),
    );
  }
}
