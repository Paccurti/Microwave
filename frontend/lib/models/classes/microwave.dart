// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Microwave {
  int id;
  int? cookingTime;
  int? potency;
  bool isRunning;

  Microwave({
    required this.id,
    this.cookingTime,
    this.potency,
    required this.isRunning,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cookingTime': cookingTime,
      'potency': potency,
      'isRunning': isRunning,
    };
  }

  factory Microwave.fromMap(Map<String, dynamic> map) {
    return Microwave(
      id: map['id'] as int,
      cookingTime: map['cookingTime'] != null ? map['cookingTime'] as int : null,
      potency: map['potency'] != null ? map['potency'] as int : null,
      isRunning: map['isRunning'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Microwave.fromJson(String source) =>
      Microwave.fromMap(json.decode(source) as Map<String, dynamic>);
}
