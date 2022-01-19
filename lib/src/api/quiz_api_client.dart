import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/src/models/models.dart';

/// Exception thrown when getCategories fails.
class CategoryRequestFailure implements Exception {}

/// Exception thrown when no categories are found.
class CategoryNotFoundFailure implements Exception {}

/// Exception thrown when getQuestions fails.
class QuestionRequestFailure implements Exception {}

/// Exception thrown when no questions found under the provided category.
class QuestionsNotFoundFailure implements Exception {}

class QuizApiClient {
  QuizApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.trivia.willfry.co.uk';
  final http.Client _httpClient;

  /// Get list of [Categories] `/categories`.
  Future<List<Category>> getCategories() async {
    final categoryRequest = Uri.https(
      _baseUrl,
      '/categories',
    );
    final categoriesResponse = await _httpClient.get(categoryRequest);

    if (categoriesResponse.statusCode != 200) {
      throw CategoryRequestFailure();
    }

    final categoryJson = jsonDecode(
      categoriesResponse.body,
    ) as List<dynamic>;

    if (categoryJson.isEmpty) {
      throw CategoryNotFoundFailure();
    }

    List<Category> categories = [];
    for (var category in categoryJson) {
      categories.add(Category.fromMap(category));
    }
    return categories;
  }

  /// Fetches [List<Question>] for a given [category].
  Future<List<Question>> getQuestions(String category, {int limit = 10}) async {
    final questionsRequest = Uri.https(
      _baseUrl,
      '/questions',
      {'limit': limit.toString(), 'categories': category},
    );
    final questionsResponse = await _httpClient.get(questionsRequest);

    if (questionsResponse.statusCode != 200) {
      throw QuestionRequestFailure();
    }

    final questionsJson = jsonDecode(questionsResponse.body) as List<dynamic>;

    if (questionsJson.isEmpty) {
      throw QuestionsNotFoundFailure();
    }

    // final questionsJson = bodyJson as List;

    if (questionsJson.isEmpty) {
      throw QuestionsNotFoundFailure();
    }

    List<Question> questions = [];
    for (var question in questionsJson) {
      questions.add(Question.fromMap(question));
    }
    return questions;
  }
}
