import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_app/src/api/models/question.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/result/result.dart';
import 'package:quiz_app/src/result/result_view.dart';

enum QuestionsFetchStatus { initial, loading, success, failure }

class Questionsview extends StatefulWidget {
  const Questionsview({Key? key, required this.questionsCategory})
      : super(key: key);

  static const routeName = '/question';
  final String questionsCategory;

  @override
  State<Questionsview> createState() => _QuestionsviewState();
}

enum QuestionStatus { correct, wrong, unanswered }

class _QuestionsviewState extends State<Questionsview> {
  QuestionsFetchStatus fetchStatus = QuestionsFetchStatus.initial;
  List<Question> questions = [];
  Map<int, QuestionStatus> questionTally = {};
  int correctAnswerCount = 0;
  int unAnsweredCount = 0;
  int inCorrectAnswerCount = 0;

  void onQuestionStatusUpdate(QuestionStatus status, int id) {
    final currentStatus = questionTally[id];
    questionTally[id] = status;

    if (currentStatus != status) {
      if (currentStatus == QuestionStatus.unanswered) {
        unAnsweredCount--;
        if (status == QuestionStatus.correct) {
          correctAnswerCount++;
        } else {
          inCorrectAnswerCount++;
        }
      } else if (currentStatus == QuestionStatus.correct) {
        correctAnswerCount--;
        inCorrectAnswerCount++;
      } else {
        correctAnswerCount++;
        inCorrectAnswerCount--;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    fetchStatus = QuestionsFetchStatus.loading;
    var apiClient = QuizApiClient();

    // fetch questions
    try {
      apiClient.getQuestions(widget.questionsCategory).then((value) {
        setState(() {
          fetchStatus = QuestionsFetchStatus.success;
          questions = value;
          unAnsweredCount = questions.length;
          for (var i = 0; i < questions.length; i++) {
            questionTally[questions[i].id] = QuestionStatus.unanswered;
          }
        });
      }).catchError((error) {
        setState(() {
          fetchStatus = QuestionsFetchStatus.failure;
        });
      });
    } catch (e) {
      setState(() {
        fetchStatus = QuestionsFetchStatus.failure;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
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
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),

        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: fetchStatus == QuestionsFetchStatus.loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Fetching Questions")
                  ],
                ),
              )
            : fetchStatus == QuestionsFetchStatus.success
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      addAutomaticKeepAlives: true,
                      // Providing a restorationId allows the ListView to restore the
                      // scroll position when a user leaves and returns to the app after it
                      // has been killed while running in the background.
                      restorationId: 'CategoryListView',
                      // itemCount: questions.length,
                      children: questions.map((question) {
                        return QuestionBox(
                          question: question,
                          onQuestionAnswer: onQuestionStatusUpdate,
                        );
                      }).toList(),
                    ),
                  )
                : const Center(
                    child: Text("Error while fetching the data"),
                  ));
  }
}

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

  List<Widget> generateChoiceWidgets(Question question) {
    correctAnswerIndex ??= correctAnswerIndex = Random().nextInt(3);
    final widgetList = <ListTile>[];
    for (var i in [for (var i = 0; i < 3; i += 1) i]) {
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
          style: const TextStyle(fontSize: 14),
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
          ...generateChoiceWidgets(widget.question)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
// question screen