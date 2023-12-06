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

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemId: json['itemId'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}

enum OrderStatus { pending, delivered, cancelled }

class Order {
  String orderId;
  String studentId;
  List<OrderItem> items;
  int totalAmount;
  String status;

  Order({
    required this.orderId,
    required this.studentId,
    required this.items,
    required this.totalAmount,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<dynamic> itemsJson = json['items'];
    List<OrderItem> orderItems =
        itemsJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      orderId: json['orderid'],
      studentId: json['studentid'],
      items: orderItems,
      totalAmount: json['totalamount'],
      status: json['status'],
    );
  }
}

class OrderItem {
  String name;
  int quantity;
  int price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
