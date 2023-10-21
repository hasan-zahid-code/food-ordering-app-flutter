import 'package:flutter/material.dart';
import 'package:dhaba/lib/pages/cart_page.dart';
import 'package:dhaba/lib/pages/classes_data.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // You can adjust the duration
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vendor.title} Menu'),
      ),
      body: Column(
        children: [
          // Horizontal Category Menu
          Container(
            height: 60, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // Handle category selection here
                    },
                    hoverColor: Colors.blue.withOpacity(0.2),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Vertical Slider with Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: widget.vendor.menuItems?.length ?? 0, // Check for null
              itemBuilder: (context, index) {
                final menuItem = widget.vendor.menuItems?[index];

                if (menuItem != null) {
                  return Card(
                    margin: EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          // Left side (heart icon)
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
                                  menuItem.isFavorite = !menuItem.isFavorite;
                                  if (menuItem.isFavorite) {
                                    User(favorites: favoriteItems)
                                        .favorites
                                        .add(menuItem);
                                  } else {
                                    User(favorites: favoriteItems)
                                        .favorites
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menuItem.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Price: ₨${menuItem.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                  // Add more details about the menu item here
                                ],
                              ),
                            ),
                          ),
                          // Image
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Image.asset(
                              menuItem.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Add to Cart button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Add the menu item to the cart
                                setState(() {
                                  if (cartItemsMap.containsKey(menuItem.name)) {
                                    // If the same item is added, increment quantity
                                    cartItemsMap[menuItem.name]!.quantity++;
                                  } else {
                                    // If a different item is added, append to the list
                                    final CartItem cartItem = CartItem(
                                      name: menuItem.name,
                                      price: menuItem.price,
                                      image: menuItem.image,
                                      quantity: 1,
                                    );
                                    cartItemsMap[menuItem.name] = cartItem;
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
                  );
                } else {
                  // Handle the case where menuItem is null
                  return Container();
                }
              },
            ),
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
