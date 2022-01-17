import 'dart:convert';

import 'package:quiz_app/src/features/questions/question_item.dart';

// category model

class CategoryItem {
  final String categoryLabel;
  final List<QuestionItem> questions;

  const CategoryItem(this.categoryLabel, this.questions);

  Map<String, dynamic> toMap() {
    return {
      'categoryLabel': categoryLabel,
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      map['categoryLabel'] ?? '',
      List<QuestionItem>.from(
          map['questions']?.map((x) => QuestionItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryItem.fromJson(String source) =>
      CategoryItem.fromMap(json.decode(source));
}
