import 'dart:convert';

// question model

class QuestionOption {
  final String option;
  final bool isAnswer;

  const QuestionOption(this.option, this.isAnswer);

  Map<String, dynamic> toMap() {
    return {
      'option': option,
      'isAnswer': isAnswer,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      map['option'] ?? '',
      map['isAnswer'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionOption.fromJson(String source) => QuestionOption.fromMap(json.decode(source));
}

class QuestionItem {
  final String question;
  final List<QuestionOption> options;

  const QuestionItem(this.question, this.options);

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  factory QuestionItem.fromMap(Map<String, dynamic> map) {
    return QuestionItem(
      map['question'] ?? '',
      List<QuestionOption>.from(map['options']?.map((x) => QuestionOption.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionItem.fromJson(String source) => QuestionItem.fromMap(json.decode(source));
}
