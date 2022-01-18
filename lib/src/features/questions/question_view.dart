import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/src/api/models/question.dart';
import 'package:quiz_app/src/features/common/responsive_widget.dart';
import 'package:quiz_app/src/features/questions/questions_handler.dart';
import 'package:quiz_app/src/features/questions/widgets/question_box.dart';
import 'package:quiz_app/src/features/result/result.dart';
import 'package:quiz_app/src/features/result/result_view.dart';

// enum QuestionsFetchStatus { initial, loading, success, failure }

class QuestionsView extends StatefulWidget {
  const QuestionsView({Key? key, required this.questionsCategory})
      : super(key: key);

  static const routeName = '/question';
  final String questionsCategory;

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

enum QuestionStatus { correct, wrong, unanswered }

class _QuestionsViewState extends State<QuestionsView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveWidget.isSmallScreen(context) == true
            ? AppBar(
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
                                    Navigator.pushNamed(
                                        context, ResultView.routeName,
                                        arguments: Result(
                                          unAnsweredCount: unAnsweredCount,
                                          correctAnswerCount:
                                              correctAnswerCount,
                                          inCorrectAnswerCount:
                                              inCorrectAnswerCount,
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
              )
            : null,
        // ToDo: Rerender the questions page showing the correct and incorrect answers once submitted

        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: Theme(
          data: ResponsiveWidget.isSmallScreen(context)
              ? Theme.of(context)
              : ThemeData.light(),
          child: Consumer<QuestionsHandler>(
            builder: (context, questionsHandler, child) {
              unAnsweredCount = questionsHandler.questions.length;
              return Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Questions',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 24,
                                  )),
                        ),
                        if (ResponsiveWidget.isSmallScreen(context) != true)
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
                                            Navigator.pushNamed(
                                                context, ResultView.routeName,
                                                arguments: Result(
                                                  unAnsweredCount:
                                                      unAnsweredCount,
                                                  correctAnswerCount:
                                                      correctAnswerCount,
                                                  inCorrectAnswerCount:
                                                      inCorrectAnswerCount,
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
                                Navigator.pushNamed(
                                    context, ResultView.routeName,
                                    arguments: Result(
                                      unAnsweredCount: unAnsweredCount,
                                      correctAnswerCount: correctAnswerCount,
                                      inCorrectAnswerCount:
                                          inCorrectAnswerCount,
                                    ));
                              }
                            },
                            child: const Text(
                              "Submit",
                            ),
                          )
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    questionsHandler.questionStatus ==
                            QuestionsFetchStatus.loading
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
                        : questionsHandler.questionStatus ==
                                QuestionsFetchStatus.success
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    addAutomaticKeepAlives: true,
                                    // Providing a restorationId allows the ListView to restore the
                                    // scroll position when a user leaves and returns to the app after it
                                    // has been killed while running in the background.
                                    restorationId: 'QuestionListView',
                                    // itemCount: questions.length,
                                    children: questionsHandler.questions
                                        .map((question) {
                                      return QuestionBox(
                                        question: question,
                                        onQuestionAnswer:
                                            onQuestionStatusUpdate,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : questionsHandler.questionStatus ==
                                    QuestionsFetchStatus.initial
                                ? const Center(
                                    child: Text(
                                      "Please select proper question category from the left panel to start the Quiz",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                : const Center(
                                    child:
                                        Text("Error while fetching the data"),
                                  ),
                  ],
                ),
                color: ResponsiveWidget.isSmallScreen(context) == true
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.white,
              );
            },
          ),
        ));
  }
}
