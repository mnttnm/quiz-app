import 'dart:convert';

// https://api.trivia.willfry.co.uk/questions?categories=movies&limit=5

// {
//   "category": "Film and TV",
//   "correctAnswer": "\"Shane. Shane. Come back!\"",
//   "id": 29269,
//   "incorrectAnswers": [
//     "\"As God is my witness, I'll never be hungry again.\"",
//     "\"I am big! It's the pictures that got small.\"",
//     "\"What\u2019s the most you ever lost on a coin toss?\"",
//     "\"I see dead people.\"",
//     "\"I'm gonna make him an offer he can't refuse.\"",
//     "\"My precious.\"",
//     "\"Mrs. Robinson, you're trying to seduce me. Aren't you?\"",
//     "\"What is this? A center for ants? How can we be expected to teach children to learn how to read\u2026if they can\u2019t even fit inside the building?\"",
//     "\"I have had it with these mother\u2014\u2014 snakes on this mother\u2014\u2014 plane!\"",
//     "\"I drink your milkshake. I drink it up.\""
//   ],
//   "question": "Which of these is a famous quote from the film 'Shane'?",
//   "type": "Multiple Choice"
// },

enum QuestionType { multipleChoice, unknown }

String questionTypeToString(QuestionType type) {
  switch (type) {
    case QuestionType.multipleChoice:
      return 'Multiple Choice';
    default:
      return 'Unknown';
  }
}

QuestionType stringToQuestionType(String type) {
  switch (type) {
    case 'Multiple Choice':
      return QuestionType.multipleChoice;
    default:
      return QuestionType.unknown;
  }
}

class Question {
  final String category;
  final String correctAnswer;
  final int id;
  final List<String> incorrectAnswers;
  final String question;
  final QuestionType type;

  Question({
    required this.category,
    required this.correctAnswer,
    required this.id,
    required this.incorrectAnswers,
    required this.question,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'correctAnswer': correctAnswer,
      'id': id,
      'incorrectAnswers': incorrectAnswers,
      'question': question,
      'type': questionTypeToString(type),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      category: map['category'] ?? '',
      correctAnswer: map['correctAnswer'] ?? '',
      id: map['id']?.toInt() ?? 0,
      incorrectAnswers: List<String>.from(map['incorrectAnswers']),
      question: map['question'] ?? '',
      type: stringToQuestionType(map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));
}
