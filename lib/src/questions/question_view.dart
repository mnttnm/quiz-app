import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class QuestionView extends StatelessWidget {
  const QuestionView({Key? key}) : super(key: key);

  static const routeName = '/question';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question'),
      ),
      body: const Center(
        child: Text('Question Text'),
      ),
    );
  }
}
// question screen