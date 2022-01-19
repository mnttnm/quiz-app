import 'package:flutter/material.dart';
import 'package:quiz_app/src/api/quiz_api_client.dart';
import 'package:quiz_app/src/models/models.dart';

enum CategoriesFetchStatus { initial, loading, success, failure }

class CategoriesHandler with ChangeNotifier {
  final QuizApiClient _apiClient;
  List<Category> categories = [];
  CategoriesFetchStatus status = CategoriesFetchStatus.initial;
  CategoriesHandler(this._apiClient);

  Future<void> fetchCategories() async {
    try {
      categories = await _apiClient.getCategories();
      status = CategoriesFetchStatus.success;
    } catch (e) {
      status = CategoriesFetchStatus.failure;
    } finally {
      notifyListeners();
    }
  }
}
