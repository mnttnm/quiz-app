import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/categories/category_list_view.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';

class WideLayout extends StatefulWidget {
  const WideLayout({
    Key? key,
    required this.categoriesHandler,
  }) : super(key: key);

  final CategoriesHandler categoriesHandler;

  @override
  State<WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<WideLayout> {
  String currentCategory = "";
  @override
  void initState() {
    super.initState();
  }

  void onCategoryChange(String category) {
    setState(() {
      currentCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CategoryListView(
            categoriesHandler: widget.categoriesHandler,
            onCategoryChangeFn: onCategoryChange,
          ),
        ),
        Expanded(
          flex: 7,
          child: Questionsview(
            questionsCategory: currentCategory,
          ),
        ),
      ],
    );
  }
}
