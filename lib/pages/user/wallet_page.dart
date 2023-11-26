import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final double walletAmount; // Assuming the wallet amount is in Rs

  WalletPage({
    required this.userName,
    required this.userEmail,
    required this.walletAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Name: $userName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Email: $userEmail',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Wallet Amount: Rs $walletAmount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
