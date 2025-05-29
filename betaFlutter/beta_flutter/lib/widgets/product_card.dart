import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final int quantity;

  const ProductCard({super.key, required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.image),
        title: Text(name),
        trailing: Text(quantity.toString()),
      ),
    );
  }
}
