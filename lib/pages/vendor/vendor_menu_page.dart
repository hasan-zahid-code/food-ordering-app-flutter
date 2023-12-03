import 'package:flutter/material.dart';
import 'package:dhaba/pages/vendor/classes_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VendorMenuPage extends StatefulWidget {
  @override
  _VendorMenuPageState createState() => _VendorMenuPageState();
}

class _VendorMenuPageState extends State<VendorMenuPage> {
  late Future<List<MenuItem>> _menuItemsFuture;

  @override
  void initState() {
    super.initState();
    _menuItemsFuture = fetchMenuItems(currentVendor.vendorid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Menu'),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _menuItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<MenuItem> menuItems = snapshot.data ?? [];

            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItemCard(menuItems[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the add menu item dialog
          _showAddMenuItemDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem menuItem) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ListTile(
        leading: SizedBox(
          width: 56.0,
          height: 56.0,
          child: Image.asset(menuItem.image),
        ),
        title: Text(menuItem.name),
        subtitle: Text('Price: Rs.${menuItem.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit menu item logic
                _showEditMenuItemDialog(menuItem);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Confirm deletion logic
                _showDeleteConfirmationDialog(menuItem.itemId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(itemId);
                setState(() {
                  menuItems.remove(itemId);
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMenuItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMenuItemDialog(
          onAddMenuItem: (MenuItem newItem) {
            setState(() {
              menuItems.add(newItem);
            });
            _addItem(newItem);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showEditMenuItemDialog(MenuItem menuItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditMenuItemDialog(
          menuItem: menuItem,
          onEditMenuItem: (MenuItem editedItem) {
            setState(() {
              int index = menuItems.indexOf(menuItem);
              if (index != -1) {
                menuItems[index] = editedItem;
              }
            });
            _updateItem(editedItem);
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  Future<void> _updateItem(MenuItem menuItem) async {
    const String url = 'http://localhost:3000/api/updateItem';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'itemId': menuItem.itemId,
          'name': menuItem.name,
          'price': menuItem.price.toString(),
          'image': menuItem.image,
        }),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final successMessage = jsonData['message'];

        final snackBar = SnackBar(
          content: Text(successMessage),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData['error'];

        final snackBar = SnackBar(
          content: Text('Menu Items Save failed: $errorMessage'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Network error.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _addItem(MenuItem menuItem) async {
    const String url = 'http://localhost:3000/api/addItem';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'vendorId': currentVendor.vendorid,
          'name': menuItem.name,
          'price': menuItem.price.toString(),
          'image': menuItem.image,
        }),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final successMessage = jsonData['message'];

        final snackBar = SnackBar(
          content: Text(successMessage),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData['error'];

        final snackBar = SnackBar(
          content: Text('Failed to add Item: $errorMessage'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Failed to add Item: Network error.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _deleteItem(String itemId) async {
    final String url = 'http://localhost:3000/api/deleteItem/$itemId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final successMessage = jsonData['message'];

        final snackBar = SnackBar(
          content: Text(successMessage),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final jsonData = json.decode(response.body);
        final errorMessage = jsonData['error'];

        final snackBar = SnackBar(
          content: Text('Item Deletion failed: $errorMessage'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Network error.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class AddMenuItemDialog extends StatefulWidget {
  final Function(MenuItem) onAddMenuItem;

  AddMenuItemDialog({required this.onAddMenuItem});

  @override
  _AddMenuItemDialogState createState() => _AddMenuItemDialogState();
}

class _AddMenuItemDialogState extends State<AddMenuItemDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Menu Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate and add the menu item
            if (_validateInputs()) {
              MenuItem newItem = MenuItem(
                itemId: '1000',
                name: _nameController.text,
                price: double.parse(_priceController.text),
                image: _imageController.text,
              );
              widget.onAddMenuItem(newItem);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (_imageController.text.isEmpty) _imageController.text = "food.png";
    return (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty);
  }
}

class EditMenuItemDialog extends StatefulWidget {
  final MenuItem menuItem;
  final Function(MenuItem) onEditMenuItem;

  EditMenuItemDialog({required this.menuItem, required this.onEditMenuItem});

  @override
  _EditMenuItemDialogState createState() => _EditMenuItemDialogState();
}

class _EditMenuItemDialogState extends State<EditMenuItemDialog> {
  TextEditingController _itemIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _itemIdController = TextEditingController(text: widget.menuItem.itemId);
    _nameController = TextEditingController(text: widget.menuItem.name);
    _priceController =
        TextEditingController(text: widget.menuItem.price.toString());
    _imageController = TextEditingController(text: widget.menuItem.image);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Menu Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _itemIdController,
            decoration: InputDecoration(labelText: 'Item ID'),
            readOnly: true,
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate and edit the menu item
            if (_validateInputs()) {
              MenuItem editedItem = MenuItem(
                itemId: _itemIdController.text,
                name: _nameController.text,
                price: double.parse(_priceController.text),
                image: _imageController.text,
              );
              widget.onEditMenuItem(editedItem);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (_imageController.text.isEmpty) _imageController.text = "food.png";
    return (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty);
  }
}

Future<List<MenuItem>> fetchMenuItems(String vendorid) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/api/menu?vendorId=$vendorid'));

  if (response.statusCode == 200) {
    menuItems = List<MenuItem>.from(json.decode(response.body).map((item) {
      return MenuItem(
        itemId: item['ITEMID'],
        name: item["ITEMNAME"],
        price: item["PRICE"].toDouble(),
        image: item["IMAGE"],
      );
    })).toList();
    return menuItems;
  }
  throw Exception();
}
