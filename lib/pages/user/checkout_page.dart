import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dhaba/pages/user/classes_data.dart';
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Calculate the total price of items in the cart
  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.cartItems) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  void placeOrder(BuildContext context) async {
    final String apiUrl = 'http://localhost:3000/api/placeOrder';

    List<Map<String, dynamic>> itemsList = [];
    cartItemsMap.forEach((key, value) {
      itemsList.add({
        'itemId': value.itemId,
        'vendorId': value.vendorId,
        'quantity': value.quantity,
      });
    });

    Map<String, dynamic> payload = {
      'userId': currentUser.studentId,
      'items': itemsList,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Order placed successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Order placed successfully');
      } else {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to place order. Status code: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
        print('Failed to place order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $error'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Error placing order: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/bg-1.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${currentUser.userName}'),
              SizedBox(height: 16),
              Text('Order Details:'),
              // Display order details here using widget.cartItems
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                      'Price: ₨${(item.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text('Total Price: ₨${calculateTotalPrice().toStringAsFixed(2)}'),
              // SizedBox(height: 16),
              // Text('Payment Method:'),
              // Display payment options (Cash, Easypaisa, Jazzcash)
              // RadioListTile(
              //   title: Text('Cash'),
              //   value: 'Cash',
              //   groupValue: paymentOption,
              //   onChanged: (value) {
              //     setState(() {
              //       paymentOption = value.toString();
              //     });
              //   },
              // ),
              // RadioListTile(
              //   title: Text('Easypaisa'),
              //   value: 'Easypaisa',
              //   groupValue: paymentOption,
              //   onChanged: (value) {
              //     setState(() {
              //       paymentOption = value.toString();
              //     });
              //   },
              // ),
              // RadioListTile(
              //   title: Text('Jazzcash'),
              //   value: 'Jazzcash',
              //   groupValue: paymentOption,
              //   onChanged: (value) {
              //     setState(() {
              //       paymentOption = value.toString();
              //     });
              //   },
              // ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => placeOrder(context),
                child: Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
