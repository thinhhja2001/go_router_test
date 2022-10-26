import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_go_router/cubits/cubit/login_cubit.dart';
import 'package:test_go_router/models/category_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Category.categories;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<LoginCubit>().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Categories'),
        backgroundColor: const Color(0xff000a1f),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          Category category = categories[index];
          return ListTile(
            title: Text(category.name),
            onTap: () {
              return context.go(
                context.namedLocation(
                  'product_list',
                  params: <String, String>{
                    'category': category.name,
                  },
                  queryParams: <String, String>{
                    'sort': 'desc',
                    'filter': '0',
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
