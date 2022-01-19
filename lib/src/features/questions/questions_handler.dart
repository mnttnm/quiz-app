import 'package:flutter/material.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/models/models.dart';

enum QuestionsFetchStatus { initial, loading, success, failure }

class QuestionsHandler with ChangeNotifier {
  final QuizApiClient _apiClient;
  QuestionsFetchStatus questionStatus = QuestionsFetchStatus.initial;
  Category? currentCategory;
  List<Question> questions = [];
  QuestionsHandler(this._apiClient);

  Future<void> fetchQuestions() async {
    try {
      questionStatus = QuestionsFetchStatus.loading;
      notifyListeners();
      questions = await _apiClient.getQuestions(currentCategory!.value);
      questionStatus = QuestionsFetchStatus.success;
    } catch (e) {
      questionStatus = QuestionsFetchStatus.failure;
    } finally {
      notifyListeners();
    }
  }
}
