import 'package:flutter/material.dart';
import 'package:dhaba/lib/pages/classes_data.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItem menuItem;
  final Function() onFavoriteToggle;
  final Function() onAddToCart;

  MenuItemWidget({
    required this.menuItem,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Left side (heart icon)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                menuItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: menuItem.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
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
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ₨${menuItem.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
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
              onPressed: onAddToCart,
              child: Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
