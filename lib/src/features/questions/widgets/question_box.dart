import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/questions/question_view.dart';
import 'package:quiz_app/src/models/models.dart';

class QuestionBox extends StatefulWidget {
  const QuestionBox(
      {Key? key, required this.question, required this.onQuestionAnswer})
      : super(key: key);

  final Question question;
  final void Function(QuestionStatus, int) onQuestionAnswer;

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox>
    with AutomaticKeepAliveClientMixin {
  int? _currentAnswer;
  int? correctAnswerIndex;
  bool isCorrect = false;

  List<Widget> generateChoiceWidgets(Question question, BuildContext context) {
    final choiceCount = min(question.incorrectAnswers.length, 2) + 1;
    correctAnswerIndex ??= correctAnswerIndex = Random().nextInt(choiceCount);
    final widgetList = <ListTile>[];
    for (var i in [for (var i = 0; i < choiceCount; i += 1) i]) {
      widgetList.add(ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Radio(
            value: i,
            groupValue: _currentAnswer,
            onChanged: (int? newValue) {
              setState(() {
                _currentAnswer = newValue!;

                if (correctAnswerIndex == newValue) {
                  isCorrect = true;
                }
              });
              widget.onQuestionAnswer(
                  correctAnswerIndex == newValue
                      ? QuestionStatus.correct
                      : QuestionStatus.wrong,
                  question.id);
            }),
        title: Text(
          i == correctAnswerIndex
              ? question.correctAnswer
              : question.incorrectAnswers[i],
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.question.question,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.blue.shade900, fontSize: 18),
          ),
          const SizedBox(
            height: 8,
          ),
          ...generateChoiceWidgets(widget.question, context)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// question screen