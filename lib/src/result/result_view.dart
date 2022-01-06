import 'package:flutter/material.dart';
import 'package:quiz_app/src/categories/category_list_view.dart';
import 'package:quiz_app/src/result/result.dart';
import 'package:quiz_app/src/settings/settings_view.dart';

class ResultView extends StatelessWidget {
  const ResultView({
    Key? key,
    required this.resultObj,
  }) : super(key: key);
  final Result resultObj;
  static const routeName = '/result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Navigate to the settings page. If the user leaves and returns
            // to the app after it has been killed while running in the
            // background, the navigation stack is restored.
            Navigator.restorablePushNamed(context, CategoryListView.routeName);
          },
        ),
        title: const Text(
          'Final Result',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Center(
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:'),
                  Text(
                      '${resultObj.unAnsweredCount + resultObj.correctAnswerCount + resultObj.inCorrectAnswerCount}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Unanswered:'),
                  Text(resultObj.unAnsweredCount.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Correct:'),
                  Text(resultObj.correctAnswerCount.toString()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Wrong:'),
                  Text(resultObj.inCorrectAnswerCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
