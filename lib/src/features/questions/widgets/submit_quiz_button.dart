import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/result/result.dart';
import 'package:quiz_app/src/features/result/result_view.dart';

class SubmitQuizButton extends StatelessWidget {
  const SubmitQuizButton({
    Key? key,
    required this.unAnsweredCount,
    required this.correctAnswerCount,
    required this.inCorrectAnswerCount,
  }) : super(key: key);

  final int unAnsweredCount;
  final int correctAnswerCount;
  final int inCorrectAnswerCount;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (unAnsweredCount > 0) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Dialog Title"),
                content: const Text(
                    "You have some unanswered questions, Do you really want to submit?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, ResultView.routeName,
                          arguments: Result(
                            unAnsweredCount: unAnsweredCount,
                            correctAnswerCount: correctAnswerCount,
                            inCorrectAnswerCount: inCorrectAnswerCount,
                          ));
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  )
                ],
              );
            },
          );
        } else {
          Navigator.pushNamed(context, ResultView.routeName,
              arguments: Result(
                unAnsweredCount: unAnsweredCount,
                correctAnswerCount: correctAnswerCount,
                inCorrectAnswerCount: inCorrectAnswerCount,
              ));
        }
      },
      child: const Text(
        "Submit",
      ),
    );
  }
}
