class Vendor {
  String vendorid;
  String name;
  String description;
  String contactNo;
  String email;

  Vendor(
      {required this.vendorid,
      required this.name,
      required this.description,
      required this.contactNo,
      required this.email});

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
    vendorid: '100001',
    name: 'hasan',
    description: 'this is my store',
    contactNo: '03212471039',
    email: 'exampple@gmail.com');
