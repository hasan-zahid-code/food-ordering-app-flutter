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
  final String vendorid;
  final String title;
  final String description;
  final IconData icon;
  final Color cardColor;
  final List<String>? categories;
  List<MenuItem> menuItems;

  FoodVendor({
    required this.vendorid,
    required this.title,
    required this.description,
    required this.icon,
    required this.cardColor,
    this.categories,
    this.menuItems = const [], // Initialize menuItems with an empty list
  });

  static Future<List<FoodVendor>> fetchVendors() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/vendors'));
    if (response.statusCode == 200) {
      final List<FoodVendor> vendors =
          List<FoodVendor>.from(json.decode(response.body).map((data) {
        return FoodVendor(
            vendorid: data['vendorId'],
            title: data['vendorName'],
            description: data['vendorDescription'],
            icon: Icons.fastfood,
            cardColor: Colors.blue,
            menuItems: data['menuItem'] ?? []);
      }));
      return vendors;
    } else {
      throw Exception('Failed to load vendors');
    }
  }
}

class MenuItem {
  final String itemId;
  final String name;
  final double price;
  final String image;
  bool isFavorite;

  MenuItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });
}

List<MenuItem> menuItems = [];

Future<void> fetchMenuItems(String vendorid) async {
  try {
    final response = await http
        .get(Uri.parse('http://localhost:3000/api/menu?vendorId=$vendorid'));

    if (response.statusCode == 200) {
      final List<MenuItem> menuItems =
          List<MenuItem>.from(json.decode(response.body).map((item) {
        return MenuItem(
          itemId: item['ITEMID'],
          name: item["ITEMNAME"],
          price: item["PRICE"].toDouble(),
          image: item["IMAGE"],
        );
      })).toList();
      print(menuItems);
    } else {
      // Handle the case where data couldn't be fetched
      print('Failed to fetch menu items');
    }
  } catch (error) {
    // Handle any errors that occur during the fetch
    print('Error menu items: $error');
  }
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

// final List<MenuItem> _shawarmaMenu = [
//   MenuItem(
//     name: 'Chicken Shawarma',
//     price: 150,
//     image: 'assets/shawarma.png',
//   ),
//   MenuItem(
//     name: 'Zinger Shawarma',
//     price: 190,
//     image: 'assets/zinger-shawarma.png',
//   ),
//   MenuItem(
//     name: 'Macroni Shawarma',
//     price: 150,
//     image: 'assets/shawarma.png',
//   ),
//   MenuItem(
//     name: 'Chicken Mayo Shawarma',
//     price: 160,
//     image: 'assets/shawarma.png',
//   ),
//   MenuItem(
//     name: 'Chicken Cheese Shawarma',
//     price: 180,
//     image: 'assets/shawarma.png',
//   ),
// ];

final List<String> categories = ['Shawarma', 'Shawarma'];

// Define cart items globally
List<CartItem> cartItems = [];

// Create a map to track the cart items with unique keys
final Map<String, CartItem> cartItemsMap = {};
