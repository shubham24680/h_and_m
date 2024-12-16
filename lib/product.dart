import 'package:flutter/material.dart';
import 'package:h_and_m/api.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.details});

  final Item details;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.details.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Image.network(
          widget.details.images,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
