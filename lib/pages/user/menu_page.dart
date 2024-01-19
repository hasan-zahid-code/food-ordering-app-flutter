//import 'package:dhaba/lib/pages/vendor_list_page.dart';
import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/cart_page.dart';
import 'package:dhaba/pages/user/classes_data.dart';

class MenuPage extends StatefulWidget {
  final FoodVendor vendor;

  MenuPage({required this.vendor});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _menuFetched = false;
  List<MenuItem>? _menuItems; // Store fetched menu items

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    // Fetch menu items when the widget is initialized
    _fetchMenuItems();
  }

  // Function to fetch menu items
  Future<void> _fetchMenuItems() async {
    try {
      List<MenuItem> menuItems = await fetchMenuItems(widget.vendor.vendorid);
      setState(() {
        _menuItems = menuItems;
        _menuFetched = true;
      });
    } catch (error) {
      // Handle error
      print('Error fetching menu items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vendor.title} Menu'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _menuFetched
                ? ListView.builder(
                    itemCount: _menuItems!.length,
                    itemBuilder: (context, index) {
                      final menuItem = _menuItems![index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            // Handle item tap
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      menuItem.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: menuItem.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        menuItem.isFavorite =
                                            !menuItem.isFavorite;
                                        if (menuItem.isFavorite) {
                                          currentUser.favorites.add(menuItem);
                                        } else {
                                          currentUser.favorites
                                              .remove(menuItem);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                // Right side (image and details)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menuItem.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Price: ₨${menuItem.price.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        // Add more details about the menu item here
                                      ],
                                    ),
                                  ),
                                ),
                                // Image
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 80,
                                    child: Image.asset(
                                      menuItem.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Add to Cart button
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add the menu item to the cart
                                      setState(() {
                                        if (cartItemsMap
                                            .containsKey(menuItem.name)) {
                                          // If the same item is added, increment quantity
                                          cartItemsMap[menuItem.name]!
                                              .quantity++;
                                        } else {
                                          // If a different item is added, append to the list
                                          final CartItem cartItem = CartItem(
                                            vendorId: widget.vendor.vendorid,
                                            itemId: menuItem.itemId,
                                            name: menuItem.name,
                                            price: menuItem.price,
                                            image: menuItem.image,
                                            quantity: 1,
                                          );
                                          cartItemsMap[menuItem.name] =
                                              cartItem;
                                        }

                                        // Trigger the bounce animation
                                        _controller.forward();
                                      });
                                    },
                                    child: Text('Add to Cart'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: cartItemsMap.values.toList(),
                    showBackButton: true,
                  ),
                ));
              },
              icon: Icon(Icons.shopping_cart),
              label: Text('Cart(${cartItemsMap.length})'),
            ),
          );
        },
      ),
    );
  }
}
