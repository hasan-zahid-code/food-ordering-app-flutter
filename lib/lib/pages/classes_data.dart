import 'package:flutter/material.dart';

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

// Define your list of categories here
final List<FoodVendor> vendors = [
  FoodVendor(
    title: 'Shawarma Corner',
    location: 'Location 1',
    description: 'Best Item in fast',
    icon: Icons.fastfood,
    cardColor: Colors.blue,
    menuItems: _shawarmaMenu,
  ),
  FoodVendor(
    title: 'Pizza Fast',
    location: 'Location 2',
    description: 'Pizza and fun',
    icon: Icons.local_pizza,
    cardColor: Colors.green,
    menuItems: _shawarmaMenu,
  ),
  FoodVendor(
    title: 'Dhaba',
    location: 'Location 3',
    description: 'Roll corner',
    icon: Icons.restaurant,
    cardColor: Colors.orange,
    menuItems: _shawarmaMenu,
  ),
  FoodVendor(
    title: 'Cafe',
    location: 'Location 4',
    description: 'Chai Baithak A/C Mahol',
    icon: Icons.local_dining,
    cardColor: Colors.purple,
    menuItems: _shawarmaMenu,
  ),
  FoodVendor(
    title: 'Chai Wala',
    location: 'Location 5',
    description: 'Khassi chai',
    icon: Icons.local_cafe,
    cardColor: Colors.red,
    menuItems: _shawarmaMenu,
  ),
];

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
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
  'Category 1',
];

// Define cart items globally
List<CartItem> cartItems = [];

// Create a map to track the cart items with unique keys
final Map<String, CartItem> cartItemsMap = {};
