import 'package:flutter/material.dart';
import 'package:dhaba/lib/pages/classes_data.dart';
import 'package:dhaba/lib/pages/payment_service.dart'; // Import the payment service

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final String customerName;

  CheckoutPage({required this.cartItems, required this.customerName});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String paymentOption = 'Cash'; // Default payment option

  // Create an instance of the PaymentService
  final PaymentService _paymentService = PaymentService();

  // Calculate the total price of items in the cart
  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.cartItems) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  // Handle the "Proceed to Pay" button tap
  void handlePayment() async {
    // Call the payment service to process the payment
    final success = await _paymentService.makePayment(
      calculateTotalPrice(),
      paymentOption,
    );

    if (success) {
      // Payment successful
      // You can navigate to a success page or perform other actions here
    } else {
      // Payment failed
      // You can show an error message to the user or handle it accordingly
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
              Text('Customer Name: ${widget.customerName}'),
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
              SizedBox(height: 16),
              Text('Payment Method:'),
              // Display payment options (Cash, Easypaisa, Jazzcash)
              RadioListTile(
                title: Text('Cash'),
                value: 'Cash',
                groupValue: paymentOption,
                onChanged: (value) {
                  setState(() {
                    paymentOption = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('Easypaisa'),
                value: 'Easypaisa',
                groupValue: paymentOption,
                onChanged: (value) {
                  setState(() {
                    paymentOption = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('Jazzcash'),
                value: 'Jazzcash',
                groupValue: paymentOption,
                onChanged: (value) {
                  setState(() {
                    paymentOption = value.toString();
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handlePayment, // Call the payment function
                child: Text('Proceed to Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
