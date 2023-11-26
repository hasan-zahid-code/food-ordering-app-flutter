import 'package:flutter/material.dart';
import 'package:dhaba/pages/user/checkout_page.dart';
import 'package:dhaba/pages/user/drawer.dart';
import 'package:dhaba/pages/user/classes_data.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final bool showBackButton;

  CartPage({required this.cartItems, required this.showBackButton});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice = 0;

    for (var item in widget.cartItems) {
      totalPrice += item.price * item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${widget.cartItems.length} items)'),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Builder(
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
      body: widget.cartItems.isNotEmpty
          ? ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return CartItemRow(
                  item: item,
                  onQuantityChanged: (newQuantity) {
                    setState(() {
                      item.quantity = newQuantity;
                      calculateTotalPrice();
                    });
                  },
                );
              },
            )
          : null,
      bottomNavigationBar: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Cart is empty. Add items to the cart.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₨${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(cartItems: widget.cartItems),
                        ),
                      );
                    },
                    child: Text('Checkout'),
                  ),
                ],
              ),
            ),
    );
  }
}

class CartItemRow extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;

  CartItemRow({required this.item, required this.onQuantityChanged});

  @override
  _CartItemRowState createState() => _CartItemRowState();
}

class _CartItemRowState extends State<CartItemRow> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(widget.item.image),
      title: Text(widget.item.name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity: ${widget.item.quantity}'),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (widget.item.quantity > 1) {
                    widget.onQuantityChanged(widget.item.quantity - 1);
                  }
                },
              ),
              Text(widget.item.quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  widget.onQuantityChanged(widget.item.quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
      trailing: Text(
        'Price: ₨${(widget.item.price * widget.item.quantity).toStringAsFixed(2)}',
      ),
    );
  }
}
