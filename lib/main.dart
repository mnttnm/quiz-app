import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/questions/questions_handler.dart';
import 'package:quiz_app/src/features/settings/settings_controller.dart';
import 'package:quiz_app/src/features/settings/settings_service.dart';

import 'src/app.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  final _apiClient = QuizApiClient();
  final categoryHandler = CategoriesHandler(_apiClient);
  categoryHandler
      .fetchCategories(); //  initiate the http call to fetch categories

  final questionsHandler = QuestionsHandler(_apiClient);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(QuizAppBase(
      categoryHandler: categoryHandler,
      questionsHandler: questionsHandler,
      settingsController: settingsController));
}

class QuizAppBase extends StatelessWidget {
  const QuizAppBase({
    Key? key,
    required this.categoryHandler,
    required this.questionsHandler,
    required this.settingsController,
  }) : super(key: key);

  final CategoriesHandler categoryHandler;
  final QuestionsHandler questionsHandler;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: categoryHandler),
        ChangeNotifierProvider.value(value: questionsHandler),
      ],
      child: QuizApp(
        settingsController: settingsController,
      ),
    );
  }
}
