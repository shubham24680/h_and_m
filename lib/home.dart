import 'dart:async';

import 'package:flutter/material.dart';
import 'package:h_and_m/api.dart';
import 'package:h_and_m/product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // API
  final RapidApi api = RapidApi();

  // Store data
  List<dynamic> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // MARK: Load Products
  Future<void> _loadProducts() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final List<dynamic> latestProducts = await api.fetchProducts();
      products.addAll(latestProducts);
    } catch (error) {
      // print("Error fetching products: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // MARK: Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter == 0 &&
              !isLoading) {
            // print("itemCount: $itemCount");
            _loadProducts();
          }
          return false;
        },
        child: GridView.builder(
          itemCount: products.length + (isLoading ? 1 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return (index < products.length)
                ? GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(details: item(products[index])),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  item(products[index]).images,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        text(item(products[index]).name),
                        text("\$ ${item(products[index]).value}"),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  text(String? text) {
    return Text(
      text ?? "...",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
