// Generate a stateless widget with a centered tesxt "Sales Screen"
import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Sales Screen',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
