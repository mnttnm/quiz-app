import 'dart:convert';

// https://api.trivia.willfry.co.uk/categories

// {
//     "label": "Music",
//     "value": "music"
// }

class Category {
  const Category({required this.label, required this.value});

  final String label;
  final String value;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  
}
