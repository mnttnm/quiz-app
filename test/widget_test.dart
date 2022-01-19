// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/features/categories/categories_handler.dart';
import 'package:quiz_app/src/features/categories/category_list_view.dart';
import 'package:quiz_app/src/features/categories/widgets/category_item.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';
import 'package:quiz_app/src/features/questions/questions_handler.dart';
import 'package:quiz_app/src/features/settings/settings_controller.dart';
import 'package:quiz_app/src/features/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  final _apiClient = QuizApiClient();
  final categoryHandler = CategoriesHandler(_apiClient);

  final questionsHandler = QuestionsHandler(_apiClient);
  group(
    'Home Page Test',
    () {
      testWidgets(
          'Home Page should show CategoryListView and QuestionsView Widgets',
          (WidgetTester tester) async {
        final myWidget = QuizAppBase(
          settingsController: settingsController,
          categoryHandler: categoryHandler,
          questionsHandler: questionsHandler,
        );

        // Build myWidget and trigger a frame.
        await tester.pumpWidget(myWidget);

        // Verify myWidget shows some text
        expect(find.byType(CategoryListView), findsOneWidget);
        expect(find.byType(QuestionsView), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });
    },
  );

  group('Categories Widget Test', () {
    testWidgets('Show placeholder if categories are not fetched yet',
        (WidgetTester tester) async {
      final myWidget = QuizAppBase(
        settingsController: settingsController,
        categoryHandler: categoryHandler,
        questionsHandler: questionsHandler,
      );
      await tester.pumpWidget(myWidget);
      expect(find.byType(CategoryItem), findsNothing);

      var finder = find.widgetWithText(Center, 'Quiz Categories');
      expect(finder, findsOneWidget);
      // await categoryHandler.fetchCategories();
      //  initiate the http call to fetch categories
    });

    testWidgets('Show cateogries once the api call is done',
        (WidgetTester tester) async {
      final myWidget = QuizAppBase(
        settingsController: settingsController,
        categoryHandler: categoryHandler,
        questionsHandler: questionsHandler,
      );
      await tester.pumpWidget(myWidget);
      expect(find.byType(CategoryItem), findsNothing);

      var finder = find.widgetWithText(Center, 'Quiz Categories');
      expect(finder, findsOneWidget);
      //  initiate the http call to fetch categories
      // todo: how to test this?
      // await categoryHandler.fetchCategories();
      // await tester.pump(const Duration(seconds: 1));
      // expect(find.byType(CategoryItem), findsWidgets);
    });
  });
}
