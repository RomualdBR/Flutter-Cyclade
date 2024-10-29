import 'package:mongo_dart/mongo_dart.dart';

class ResultatTest {
  final String id;
  final String id_user;
  final String id_test;
  final int score;
  final DateTime date;

  ResultatTest({required this.id, required this.id_user, required this.id_test, required this.score, required this.date});

  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'id_user': id_user,
        'id_test': id_test,
        'score': score,
        'date': date,
      };

  factory ResultatTest.fromJson(Map<String, dynamic> json) => ResultatTest(
        id: (json['_id'] as ObjectId).toHexString(),
        id_user: json['id_user'] ?? '',
        id_test: json['id_test'] ?? '',
        score: json['score'] ?? 0,
        date: json['date'] ?? DateTime(2024,9,7,17,30),
      );
}
