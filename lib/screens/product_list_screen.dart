import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_go_router/models/product_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.category,
    required this.asc,
    required this.quantity,
  });
  final String category;
  final bool asc;
  final int quantity;
  @override
  Widget build(BuildContext context) {
    List<Product> products = Product.products
        .where((product) => product.category == category)
        .where((product) => product.quantity > quantity)
        .toList();

    products.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xff000a1f),
        actions: [
          IconButton(
            onPressed: () {
              String sort = asc ? 'desc' : 'asc';
              return context.goNamed(
                'product_list',
                params: <String, String>{
                  'category': category,
                },
                queryParams: <String, String>{'sort': sort},
              );
            },
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: () {
              String sort = asc ? 'desc' : 'asc';
              return context.goNamed(
                'product_list',
                params: <String, String>{
                  'category': category,
                },
                queryParams: <String, String>{'filter': '10'},
              );
            },
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final Product product in asc ? products : products.reversed)
            ListTile(
              title: Text(product.name),
            )
        ],
      ),
    );
  }
}
