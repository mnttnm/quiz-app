import 'package:flutter/material.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/categories/categories_handler.dart';
import 'package:quiz_app/src/settings/settings_controller.dart';
import 'package:quiz_app/src/settings/settings_service.dart';

import 'src/app.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  final categoryHandler = CategoriesHandler(QuizApiClient());

  categoryHandler.fetchCategories();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(QuizApp(
    settingsController: settingsController,
    categoriesHandler: categoryHandler,
  ));
}
