import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/questions/questions_handler.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({
    Key? key,
    required this.onCategoryChangeFn,
  }) : super(key: key);

  static const routeName = '/category';

  final void Function(String category)? onCategoryChangeFn;
  @override
  Widget build(BuildContext context) {
    final questionHandler =
        Provider.of<QuestionsHandler>(context, listen: false);
    return Scaffold(
      body: Consumer<CategoriesHandler>(
          builder: (context, categoriesHandler, child) {
        switch (categoriesHandler.status) {
          case CategoriesFetchStatus.loading:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Fetching Quiz Categories")
                ],
              ),
            );
          case CategoriesFetchStatus.success:
            return Column(
              children: [
                const Align(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                const Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'CategoryListView',
                    primary:
                        false, // was getting "Scroll Controller Could Not Attached to Any Scroll Views In Flutter if not set
                    itemCount: categoriesHandler.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final categoryItem = categoriesHandler.categories[index];
                      return ListTile(
                          title: Align(
                            child: Text(categoryItem.label),
                            alignment: Alignment.center,
                          ),
                          onTap: () {
                            questionHandler.currentCategory = categoryItem;
                            questionHandler.fetchQuestions();
                            onCategoryChangeFn!(categoryItem.value);
                          });
                    },
                  ),
                ),
              ],
            );

          case CategoriesFetchStatus.failure:
            return const Center(
              child: Text("Error while fetching the data"),
            );
          default:
            return const Center(
              child: Text("Quiz Categories"),
            );
        }
      }),
    );
  }
}
