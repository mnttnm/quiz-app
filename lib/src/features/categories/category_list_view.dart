import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView(
      {Key? key,
      required this.categoriesHandler,
      required this.onCategoryChangeFn})
      : super(key: key);

  static const routeName = '/category';

  final CategoriesHandler categoriesHandler;
  final void Function(String category)? onCategoryChangeFn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedBuilder(
            animation: categoriesHandler,
            builder: (context, child) {
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
                          itemCount: categoriesHandler.categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            final categoryItem =
                                categoriesHandler.categories[index];
                            return ListTile(
                                title: Align(
                                  child: Text(categoryItem.label),
                                  alignment: Alignment.center,
                                ),
                                onTap: () {
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
            }));
  }
}
