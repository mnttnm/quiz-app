import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/home_screen/narrow_layout.dart';
import 'package:quiz_app/src/features/home_screen/wide_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key, required this.categoriesHandler}) : super(key: key);
  static const routeName = '/';
  final CategoriesHandler categoriesHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Split View
          if (constraints.maxWidth > 600) {
            return WideLayout(categoriesHandler: categoriesHandler);
          } else {
            return NarrowLayout(categoriesHandler: categoriesHandler);
          }
        },
      ),
    );
  }
}
