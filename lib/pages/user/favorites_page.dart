import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/classes_data.dart';
import 'package:dhaba/pages/user/drawer.dart';

class FavoritesPage extends StatefulWidget {
  final User favoriteItems; // Pass UserFavoriteItems

  FavoritesPage({required this.favoriteItems});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
      ),
      drawer: globalDrawer(context),
      body: Center(
        child: widget.favoriteItems.favorites.isEmpty
            ? Text('No favorite items, add items from the menu',
                style: TextStyle(fontSize: 18))
            : ListView.builder(
                itemCount: widget.favoriteItems.favorites.length,
                itemBuilder: (context, index) {
                  final favoriteItem = widget.favoriteItems.favorites[index];
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
                                favoriteItem.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favoriteItem.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                _showRemoveConfirmationDialog(favoriteItem);
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
                                    favoriteItem.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Price: ₨${favoriteItem.price.toStringAsFixed(2)}',
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
                              favoriteItem.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Add to Cart button
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle adding to the cart here
                                setState(() {
                                  if (cartItemsMap
                                      .containsKey(favoriteItem.name)) {
                                    // If the same item is added, increment quantity
                                    cartItemsMap[favoriteItem.name]!.quantity++;
                                  } else {
                                    // If a different item is added, append to the list
                                    final CartItem cartItem = CartItem(
                                      vendorId: favoriteItem.vendorId,
                                      itemId: favoriteItem.itemId,
                                      name: favoriteItem.name,
                                      price: favoriteItem.price,
                                      image: favoriteItem.image,
                                      quantity: 1,
                                    );
                                    cartItemsMap[favoriteItem.name] = cartItem;
                                  }
                                });
                              },
                              child: Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(MenuItem favoriteItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove from Favorites'),
          content: Text(
              'Are you sure you want to remove this item from your favorites?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  favoriteItem.isFavorite = false;
                  widget.favoriteItems.favorites.remove(favoriteItem);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
