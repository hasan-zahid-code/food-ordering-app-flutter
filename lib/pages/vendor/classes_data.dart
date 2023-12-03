class Vendor {
  String vendorid;
  String name;
  String description;
  String contactNo;
  String email;

  Vendor({
    required this.vendorid,
    required this.name,
    required this.description,
    required this.contactNo,
    required this.email,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorid: json['vendorId'],
      contactNo: json['contactNo'],
      name: json["vendorName"],
      description: json["Description"],
      email: json["Email"],
    );
  }
}

Vendor currentVendor = Vendor(
    vendorid: '123456',
    name: 'hasan',
    description: 'this is my store',
    contactNo: '03212471039',
    email: 'exampple@gmail.com');

List<MenuItem> menuItems = [
  MenuItem(
      itemId: '10001',
      name: 'Burger',
      price: 5.99,
      image: 'assets/shawarma.png'),
  MenuItem(
      itemId: '10001', name: 'Pizza', price: 8.99, image: 'assets/pizza.jpg'),
];

class MenuItem {
  final String itemId;
  final String name;
  final double price;
  final String image;

  MenuItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.image,
  });
}

// Dummy data for testing, replace this with your actual order data
final List<Order> Orders = [
  Order(
      orderId: '1',
      customerName: 'John Doe',
      item: 'Burger',
      total: 10.0,
      quantity: 2,
      orderStatus: OrderStatus.pending),
  Order(
      orderId: '2',
      customerName: 'Jane Doe',
      item: 'Pizza',
      total: 15.0,
      quantity: 1,
      orderStatus: OrderStatus.delivered),
  Order(
      orderId: '3',
      customerName: 'Bob Smith',
      item: 'Salad',
      total: 8.0,
      quantity: 3,
      orderStatus: OrderStatus.pending),
  // Add more orders as needed
];

class Order {
  final String orderId;
  final String customerName;
  final String item;
  final double total;
  final int quantity;
  OrderStatus orderStatus;

  Order({
    required this.orderId,
    required this.customerName,
    required this.item,
    required this.total,
    required this.quantity,
    required this.orderStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      customerName: json['customerName'],
      item: json['item'],
      total: json['total'].toDouble(),
      quantity: json['quantity'],
      orderStatus: json['orderStatus'] == 'pending'
          ? OrderStatus.pending
          : OrderStatus.delivered,
    );
  }
}

enum OrderStatus { pending, delivered }
