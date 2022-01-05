import 'package:flutter/material.dart';
import 'package:quiz_app/src/categories/categories_handler.dart';
import 'package:quiz_app/src/questions/question_view.dart';
import 'package:quiz_app/src/settings/settings_view.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({Key? key, required this.categoriesHandler})
      : super(key: key);

  static const routeName = '/';

  final CategoriesHandler categoriesHandler;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Categories'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
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
                  return ListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'CategoryListView',
                    itemCount: categoriesHandler.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final categoryItem = categoriesHandler.categories[index];
                      return ListTile(
                          title: Align(
                            child: Text(categoryItem.label),
                            alignment: Alignment.center,
                          ),
                          onTap: () {
                            Navigator.restorablePushNamed(
                              context,
                              QuestionView.routeName,
                            );
                          });
                    },
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
