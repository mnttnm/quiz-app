import 'package:flutter/material.dart';
import 'package:quiz_app/src/api/models/question.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/features/common/responsive_widget.dart';
import 'package:quiz_app/src/features/questions/widgets/question_box.dart';
import 'package:quiz_app/src/features/result/result.dart';
import 'package:quiz_app/src/features/result/result_view.dart';

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

  void fetchQuestions() {
    if (widget.questionsCategory.isNotEmpty) {
      var apiClient = QuizApiClient();
      setState(() {
        fetchStatus = QuestionsFetchStatus.loading;
      });
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
    }
  }

  @override
  void didUpdateWidget(covariant Questionsview oldWidget) {
    if (widget.questionsCategory != oldWidget.questionsCategory) {
      fetchQuestions();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    fetchStatus = QuestionsFetchStatus.initial;
    fetchQuestions();
    super.initState();
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

        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: Theme(
          data: ResponsiveWidget.isSmallScreen(context)
              ? Theme.of(context)
              : ThemeData.light(),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Questions',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
                        ),
                      )
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                fetchStatus == QuestionsFetchStatus.loading
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
                        ? Expanded(
                            child: Padding(
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
                            ),
                          )
                        : fetchStatus == QuestionsFetchStatus.initial
                            ? const Center(
                                child: Text(
                                  "Please select proper question category from the left panel to start the Quiz",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : const Center(
                                child: Text("Error while fetching the data"),
                              ),
              ],
            ),
            color: ResponsiveWidget.isSmallScreen(context) == true
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.white,
          ),
        ));
  }
}
