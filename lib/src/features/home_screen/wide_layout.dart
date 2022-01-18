import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/category_list_view.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';

class WideLayout extends StatefulWidget {
  const WideLayout({
    Key? key,
  }) : super(key: key);

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
    // this lead to widget re-rendering and hence the QuestionsView get re-rendered

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
            onCategoryChangeFn: onCategoryChange,
          ),
        ),
        Expanded(
          flex: 7,
          child: QuestionsView(
            questionsCategory: currentCategory,
          ),
        ),
      ],
    );
  }
}
