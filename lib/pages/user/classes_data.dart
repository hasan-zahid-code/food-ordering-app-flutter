import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

IconData getFoodIcon(String vendorName) {
  // Icons.fastfood,
  // Icons.restaurant,
  // Icons.local_pizza,
  // Icons.local_cafe,
  // Icons.local_dining,
  // Icons.local_bar

  if (vendorName.contains('Pizza'))
    return Icons.local_pizza_outlined;
  else if (vendorName.contains('Shawarma'))
    return Icons.fastfood;
  else if (vendorName.contains('Cafe'))
    return Icons.local_dining;
  else if (vendorName.contains('Juice'))
    return Icons.local_bar;
  else
    return Icons.restaurant_menu;
}

Future<List<MenuItem>> fetchMenuItems(String vendorid) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/api/menu?vendorId=$vendorid'));

  if (response.statusCode == 200) {
    _listOfMenuItems =
        List<MenuItem>.from(json.decode(response.body).map((item) {
      return MenuItem(
        vendorId: item['VENDORID'],
        itemId: item['ITEMID'],
        name: item["ITEMNAME"],
        price: item["PRICE"].toDouble(),
        image: item["IMAGE"],
        isFavorite: currentUser.favorites
            .any((favItem) => favItem.itemId == item['ITEMID']),
      );
    })).toList();
    return _listOfMenuItems;
  }
  throw Exception();
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
          icon: getFoodIcon(data['vendorName']),
          cardColor: Colors.blue,
          menuItems: _listOfMenuItems);
    }));

    return vendors;
  }
  throw Exception();
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
  void clear() {
    studentId = null;
    userName = null;
    favorites.clear(); // Clear the favorites list
  }
}

User currentUser = User(favorites: []);

class FoodVendor {
  String vendorid;
  String title;
  String description;
  IconData icon;
  Color cardColor;
  List<String>? categories;
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
  void clear() {
    vendorid = '';
    title = '';
    description = '';
    categories = null;
    menuItems = [];
  }
}

class MenuItem {
  String vendorId;
  String itemId;
  String name;
  double price;
  String image;
  bool isFavorite;

  MenuItem({
    required this.vendorId,
    required this.itemId,
    required this.name,
    required this.price,
    required this.image,
    this.isFavorite = false,
  });
  void clear() {
    vendorId = '';
    name = '';
    itemId = '';
    image = '';
    price = 0;
    isFavorite = false;
  }
}

class CartItem {
  String vendorId;
  String itemId;
  String name;
  int quantity;
  String image;
  double price;

  CartItem({
    required this.vendorId,
    required this.itemId,
    required this.name,
    this.quantity = 1,
    required this.image,
    required this.price,
  });
  void clear() {
    vendorId = '';
    name = '';
    itemId = '';
    image = '';
    price = 0;
    quantity = 0;
  }
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

final List<String> categories = [];

// Define cart items globally
//List<CartItem> cartItems = [];

// Create a map to track the cart items with unique keys
final Map<String, CartItem> cartItemsMap = {};
