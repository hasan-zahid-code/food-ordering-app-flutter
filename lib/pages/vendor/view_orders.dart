import 'package:flutter/material.dart';
import 'package:dhaba/pages/vendor/classes_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class OrderNotifier extends ChangeNotifier {
  List<Order> get orders => _orders;
  List<Order> _orders = [];
  int _fetchAttempts = 0;
  static const int maxFetchAttempts = 10;
  late Timer _fetchTimer;

  OrderNotifier() {
    // Set up a periodic timer to fetch orders every 1 second
    _fetchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_fetchAttempts < maxFetchAttempts) {
        fetchOrders();
        _fetchAttempts++;
      } else {
        _fetchTimer.cancel(); // Stop fetching after maxFetchAttempts
      }
    });
  }

  Future<void> fetchOrders() async {
    // Replace the URL with your actual backend API endpoint
    const String apiUrl = 'http://example.com/api/orders';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response and update the orders list
        List<dynamic> jsonData = response.body as List<dynamic>;
        _orders = jsonData.map((data) => Order.fromJson(data)).toList();
        sortOrders();
        notifyListeners();
      } else {
        // Handle errors here
        print('Failed to fetch orders. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors here
      print('Error fetching orders: $error');
    }
  }

  void addOrder(Order order) {
    _orders.add(order);
    sortOrders();
    notifyListeners();
  }

  void sortOrders() {
    _orders.sort((a, b) {
      if (a.orderStatus == OrderStatus.pending &&
          b.orderStatus == OrderStatus.delivered) {
        return -1;
      } else if (a.orderStatus == OrderStatus.delivered &&
          b.orderStatus == OrderStatus.pending) {
        return 1;
      } else {
        return 0;
      }
    });
    notifyListeners();
  }
}

class ViewOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderNotifier(),
      child: _ViewOrdersPage(),
    );
  }
}

class _ViewOrdersPage extends StatefulWidget {
  @override
  _ViewOrdersPageState createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<_ViewOrdersPage> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is initialized
    Provider.of<OrderNotifier>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
      ),
      body: Consumer<OrderNotifier>(
        builder: (context, orderNotifier, child) {
          return ListView.builder(
            itemCount: orderNotifier.orders.length,
            itemBuilder: (context, index) {
              final order = orderNotifier.orders[index];
              return _buildOrderCard(context, order, orderNotifier);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    OrderNotifier orderNotifier,
  ) {
    Color statusColor =
        order.orderStatus == OrderStatus.pending ? Colors.orange : Colors.green;

    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('Order ID: ${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}'),
            Text('Item: ${order.item}'),
            Text('Quantity: ${order.quantity}'),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            Text(
              'Status: ${order.orderStatus == OrderStatus.pending ? 'Pending' : 'Delivered'}',
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
        onTap: () {
          // Show order details dialog
          _showOrderDetailsDialog(context, order, orderNotifier);
        },
      ),
    );
  }

  void _showOrderDetailsDialog(
      BuildContext context, Order order, OrderNotifier orderNotifier) {
    Color statusColor =
        order.orderStatus == OrderStatus.pending ? Colors.orange : Colors.green;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${order.orderId}'),
              Text('Customer: ${order.customerName}'),
              Text('Item: ${order.item}'),
              Text('Quantity: ${order.quantity}'),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
              Text(
                'Status: ${order.orderStatus == OrderStatus.pending ? 'Pending' : 'Delivered'}',
                style: TextStyle(color: statusColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Change order status to delivered
                order.orderStatus = OrderStatus.delivered;
                orderNotifier.sortOrders();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Mark as Delivered'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
