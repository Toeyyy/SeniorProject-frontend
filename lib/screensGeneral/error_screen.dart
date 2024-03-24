import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404 ERROR',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              "This page doesn't exist",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
