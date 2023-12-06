import 'package:flutter/material.dart';
import 'package:dhaba/pages/vendor/classes_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class OrderNotifier extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  set selectedStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  OrderNotifier() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    // Replace the URL with your actual backend API endpoint
    final String apiUrl =
        'http://localhost:3000/api/getOrders?vendorId=${currentVendor.vendorid}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response and update the orders list
        List<dynamic> jsonData = json.decode(response.body);

        List<Order> fetchedOrders =
            jsonData.map((data) => Order.fromJson(data)).toList();
        print(fetchedOrders);
        // Clear existing orders and add the fetched ones
        _orders.clear();
        _orders.addAll(fetchedOrders);

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

  Future<void> updateOrderStatus(
      Order order, String status, BuildContext context) async {
    final String apiUrl =
        'http://localhost:3000/api/updateOrderStatus?orderId=${order.orderId}&status=${status}';

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        order.status = status;

        sortOrders();
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update Successful. ${status}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update status to ${status}. Status code: ${response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Display a network error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error in update status: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void sortOrders() {
    _orders.sort((a, b) {
      if (a.status == OrderStatus.pending &&
          b.status == OrderStatus.delivered) {
        return -1;
      } else if (a.status == OrderStatus.delivered &&
          b.status == OrderStatus.pending) {
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

class _ViewOrdersPageState extends State<_ViewOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Orders'),
            Tab(text: 'Delivered Orders'),
            Tab(text: 'Cancelled Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('pending'),
          _buildOrdersList('delivered'),
          _buildOrdersList('cancelled'),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String orderStatus) {
    return Consumer<OrderNotifier>(
      builder: (context, orderNotifier, child) {
        List<Order> orders = orderNotifier.orders
            .where((order) => order.status.toLowerCase() == orderStatus)
            .toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderCard(context, order);
          },
        );
      },
    );
  }

  String _buildItemsList(List<OrderItem> items) {
    return items.map((item) => '${item.name} (${item.price})').join(', ');
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'delivered':
        statusColor = Colors.green;
        statusText = 'Delivered';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        break;
    }

    if (_tabController.index == 1 && order.status == 'delivered') {
      // If in the "Delivered" tab, set status text to 'Delivered' for delivered orders
      statusText = 'Delivered';
    }

    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('Order ID: ${order.orderId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.studentId}'),
            Text('Items: ${_buildItemsList(order.items)}'),
            Text('Quantity: ${order.items.length}'),
            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
            Text(
              'Status: $statusText',
              style: TextStyle(color: statusColor),
            ),
          ],
        ),
        onTap: () {
          _showOrderDetailsDialog(context, order);
        },
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Order order) {
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
              Text('Customer: ${order.studentId}'),
              SizedBox(height: 10),
              _buildItemsTable(order.items),
              SizedBox(height: 10),
              Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text(
                'Status: ${order.status == 'pending' ? 'Pending' : (order.status == 'delivered' ? 'Delivered' : 'Cancelled')}',
                style: TextStyle(
                  color: order.status == 'pending'
                      ? Colors.orange
                      : (order.status == 'delivered'
                          ? Colors.green
                          : Colors.red),
                ),
              ),
            ],
          ),
          actions: [
            if (order.status == 'pending')
              TextButton(
                onPressed: () {
                  Provider.of<OrderNotifier>(context, listen: false)
                      .updateOrderStatus(order, 'delivered', context);
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

  Widget _buildItemsTable(List<OrderItem> items) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(child: Center(child: Text('Item Name'))),
            TableCell(child: Center(child: Text('Quantity'))),
            TableCell(child: Center(child: Text('Price'))),
          ],
        ),
        for (var item in items)
          TableRow(
            children: [
              TableCell(child: Text(item.name)),
              TableCell(child: Center(child: Text(item.quantity.toString()))),
              TableCell(
                child: Center(
                  child: Text('\Rs.${item.price.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
