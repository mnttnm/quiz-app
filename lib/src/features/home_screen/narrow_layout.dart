import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/category_list_view.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';

class NarrowLayout extends StatelessWidget {
  const NarrowLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CategoryListView(
          onCategoryChangeFn: (String category) => {
            Navigator.restorablePushNamed(context, QuestionsView.routeName,
                arguments: {"category": category})
          },
        ))
      ],
    );
  }
}
