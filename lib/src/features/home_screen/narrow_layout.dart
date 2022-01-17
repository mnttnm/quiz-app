import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/categories/category_list_view.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';

class NarrowLayout extends StatelessWidget {
  const NarrowLayout({
    Key? key,
    required this.categoriesHandler,
  }) : super(key: key);

  final CategoriesHandler categoriesHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CategoryListView(
          onCategoryChangeFn: (String category) => {
            Navigator.restorablePushNamed(context, Questionsview.routeName,
                arguments: {"category": category})
          },
          categoriesHandler: categoriesHandler,
        ))
      ],
    );
  }
}
