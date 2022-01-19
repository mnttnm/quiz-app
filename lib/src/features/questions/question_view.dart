import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/src/features/common/responsive_widget.dart';
import 'package:quiz_app/src/features/questions/questions_handler.dart';
import 'package:quiz_app/src/features/questions/widgets/question_box.dart';
import 'package:quiz_app/src/features/questions/widgets/submit_quiz_button.dart';
import 'package:quiz_app/src/models/models.dart';

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubmitQuizButton(
                        unAnsweredCount: unAnsweredCount,
                        correctAnswerCount: correctAnswerCount,
                        inCorrectAnswerCount: inCorrectAnswerCount),
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
              var theme = Theme.of(context);
              unAnsweredCount = questionsHandler.questions.length;
              return Container(
                child: Column(
                  children: [
                    QuestionViewHeader(
                      theme: theme,
                      unAnsweredCount: unAnsweredCount,
                      correctAnswerCount: correctAnswerCount,
                      inCorrectAnswerCount: inCorrectAnswerCount,
                      questionsCategory: widget.questionsCategory,
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

class QuestionViewHeader extends StatelessWidget {
  const QuestionViewHeader({
    Key? key,
    required this.theme,
    required this.unAnsweredCount,
    required this.correctAnswerCount,
    required this.inCorrectAnswerCount,
    required this.questionsCategory,
  }) : super(key: key);

  final ThemeData theme;
  final int unAnsweredCount;
  final int correctAnswerCount;
  final int inCorrectAnswerCount;
  final String questionsCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${questionsCategory.toUpperCase()} Questions',
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 24,
              )),
        ),
        if (ResponsiveWidget.isSmallScreen(context) != true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubmitQuizButton(
                unAnsweredCount: unAnsweredCount,
                correctAnswerCount: correctAnswerCount,
                inCorrectAnswerCount: inCorrectAnswerCount),
          )
      ],
    );
  }
}
