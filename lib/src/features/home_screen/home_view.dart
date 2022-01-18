import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/common/responsive_widget.dart';
import 'package:quiz_app/src/features/home_screen/narrow_layout.dart';
import 'package:quiz_app/src/features/home_screen/wide_layout.dart';
import 'package:quiz_app/src/features/settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key, required this.categoriesHandler}) : super(key: key);
  static const routeName = '/';
  final CategoriesHandler categoriesHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz App"),
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
        body: ResponsiveWidget(
          largeScreen: WideLayout(categoriesHandler: categoriesHandler),
          smallScreen: NarrowLayout(categoriesHandler: categoriesHandler),
        ));
  }
}
