import 'package:mongo_dart/mongo_dart.dart';

// Modèle de la table "resultat_test", gère la structure de la table
class ResultatTest {
  // Définit les élements de la table
  final String id;
  final String id_user;
  final String id_test;
  final int score;
  final DateTime date;

  // Le constructeur
  ResultatTest({required this.id, required this.id_user, required this.id_test, required this.score, required this.date});

  // Mettre sous JSON
  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'id_user': id_user,
        'id_test': id_test,
        'score': score,
        'date': date,
      };

  // Mettre le JSON en donnée MongoDB (qui ne supporte que le JSON)
  factory ResultatTest.fromJson(Map<String, dynamic> json) => ResultatTest(
        id: (json['_id'] as ObjectId).toHexString(),
        id_user: json['id_user'] ?? '',
        id_test: json['id_test'] ?? '',
        score: json['score'] ?? 0,
        date: json['date'] ?? DateTime(2024,9,7,17,30),
      );

   @override
  String toString() => '$score';
}
