class Vendor {
  String? vendorid;
  String? name;
  String? description;
  String? contactNo;
  String? email;

  Vendor(
      {this.vendorid, this.name, this.description, this.contactNo, this.email});

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

Vendor currentVendor = Vendor();
