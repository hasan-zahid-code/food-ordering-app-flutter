import 'package:flutter/material.dart';

class AboutDevelopersPage extends StatelessWidget {
  final List<Developer> developers = [
    Developer(
        name: 'Abdullah Siddiqui',
        id: '21K-3447',
        image: 'assets/abdullah.jpg',
        cardColor: Colors.red),
    Developer(
        name: 'Hasan Zahid',
        id: '21K-4872',
        image: 'assets/suited.jpg',
        cardColor: Colors.blue),
    Developer(
        name: 'Huzaifa Siddiqui',
        id: '21K-3376',
        image: 'food.png',
        cardColor: Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Developers'),
      ),
      body: ListView.builder(
        itemCount: developers.length,
        itemBuilder: (context, index) {
          final developer = developers[index];
          return GestureDetector(
            onTap: () {
              _showDeveloperDialog(context, developer);
            },
            child: Card(
              margin: EdgeInsets.all(12.0),
              color: Colors.blue, // You can customize the color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      developer.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${developer.id}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showDeveloperDialog(BuildContext context, Developer developer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(developer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              developer.image,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Text('${developer.id}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Developer {
  final String name;
  final String id;
  final String image;
  final Color cardColor;

  Developer({
    required this.name,
    required this.id,
    required this.image,
    required this.cardColor,
  });
}
