import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//DATA FETCHING FUNCTIONS
Future<List<MenuItem>?> fetchMenuItems(String vendorid) async {
  try {
    final response = await http
        .get(Uri.parse('http://localhost:3000/api/menu?vendorId=$vendorid'));

    if (response.statusCode == 200) {
      _listOfMenuItems =
          List<MenuItem>.from(json.decode(response.body).map((item) {
        return MenuItem(
          itemId: item['ITEMID'],
          name: item["ITEMNAME"],
          price: item["PRICE"].toDouble(),
          image: item["IMAGE"],
        );
      })).toList();
      return _listOfMenuItems;
    } else {
      // Handle the case where data couldn't be fetched
      print('Failed to fetch menu items for vendor $vendorid');
      return null; // Return null to indicate failure
    }
  } catch (error) {
    // Handle any errors that occur during the fetch
    print('Error menu items: $error');
    return null; // Return null to indicate failure
  }
}

Future<List<FoodVendor>> fetchVendors() async {
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
          menuItems: _listOfMenuItems);
    }));

    return vendors;
  } else {
    throw Exception('Failed to load vendors');
  }
}

class User {
  String? studentId;
  String? userName;
  List<MenuItem> favorites;

  User({
    this.studentId,
    this.userName,
    required this.favorites,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      studentId: json['studentId'],
      userName: json['userName'],
      favorites: [], // Initialize favorites as an empty list
    );
  }
  void printFavorites() {
    for (MenuItem item in favorites) {
      print('Favorite Item: ${item.name}');
    }
  }
}

User currentUser = User(favorites: []);

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
    this.menuItems = const [],
  });
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

List<MenuItem> _listOfMenuItems = [
  // MenuItem(
  //   itemId: "1001",
  //   name: 'Chicken Shawarma',
  //   price: 150,
  //   image: 'assets/shawarma.png',
  // ),
  // MenuItem(
  //   itemId: "1002",
  //   name: 'Zinger Shawarma',
  //   price: 190,
  //   image: 'assets/zinger-shawarma.png',
  // ),
  // MenuItem(
  //   itemId: "1003",
  //   name: 'Macroni Shawarma',
  //   price: 150,
  //   image: 'assets/shawarma.png',
  // ),
  // MenuItem(
  //   itemId: "1004",
  //   name: 'Chicken Mayo Shawarma',
  //   price: 160,
  //   image: 'assets/shawarma.png',
  // ),
  // MenuItem(
  //   itemId: "1005",
  //   name: 'Chicken Cheese Shawarma',
  //   price: 180,
  //   image: 'assets/shawarma.png',
  // ),
];

final List<String> categories = ['Shawarma', 'Shawarma'];

// Define cart items globally
List<CartItem> cartItems = [];

// Create a map to track the cart items with unique keys
final Map<String, CartItem> cartItemsMap = {};
