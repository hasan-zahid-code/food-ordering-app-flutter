import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  List<MenuItem> favorites;

  User({
    required this.favorites,
  });
}

// Sample data for a user's favorite items
final List<MenuItem> favoriteItems = [];

class FoodVendor {
  final String title;
  final String location;
  final String description;
  final IconData icon;
  final Color cardColor;
  final List<String>? categories;
  final List<MenuItem>? menuItems;

  FoodVendor({
    required this.title,
    required this.location,
    required this.description,
    required this.icon,
    required this.cardColor,
    this.categories,
    this.menuItems,
  });

  static Future<List<FoodVendor>> fetchVendors() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/vendors'));

    if (response.statusCode == 200) {
      final List<FoodVendor> vendors =
          List<FoodVendor>.from(json.decode(response.body).map((data) {
        print(response.body);
        return FoodVendor(
          title: data['vendorName'] ?? 'Default Title',
          location: data['vendorLocation'] ?? 'Default Location',
          description: data['vendorDescription'] ?? 'Default Description',
          icon: Icons.fastfood,
          cardColor: Colors.blue,
          menuItems: _shawarmaMenu,
        );
      }));
      return vendors;
    } else {
      throw Exception('Failed to load vendors');
    }
  }
}

class MenuItem {
  final String name;
  final double price;
  final String image;
  bool isFavorite; // Add isFavorite variable

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    this.isFavorite = false, // Default value is false
  });
}

class CartItem {
  final String name;
  int quantity;
  final String image;
  final double price;

  CartItem({
    required this.name,
    this.quantity = 1,
    required this.image,
    required this.price,
  });
}

final List<MenuItem> _shawarmaMenu = [
  MenuItem(
    name: 'Chicken Shawarma',
    price: 150,
    image: 'assets/shawarma.png',
  ),
  MenuItem(
    name: 'Zinger Shawarma',
    price: 190,
    image: 'assets/zinger-shawarma.png',
  ),
  MenuItem(
    name: 'Macroni Shawarma',
    price: 150,
    image: 'assets/shawarma.png',
  ),
  MenuItem(
    name: 'Chicken Mayo Shawarma',
    price: 160,
    image: 'assets/shawarma.png',
  ),
  MenuItem(
    name: 'Chicken Cheese Shawarma',
    price: 180,
    image: 'assets/shawarma.png',
  ),
];

final List<String> categories = [
  'Shawarma',
];

// Define cart items globally
List<CartItem> cartItems = [];

// Create a map to track the cart items with unique keys
final Map<String, CartItem> cartItemsMap = {};
