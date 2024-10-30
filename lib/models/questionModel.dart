import 'package:mongo_dart/mongo_dart.dart';

// Modèle de la table "question", gère la structure de la table
class Question {
  // Définit les élements de la table
  final String id;
  final String id_test;
  final String intitule;
  final String proposition_1;
  final String proposition_2;
  final String proposition_3;
  final String proposition_4;
  final int reponse;
  final int seconds;

  // Le constructeur
  Question({required this.id, required this.id_test, required this.intitule, required this.proposition_1, required this.proposition_2, required this.proposition_3, required this.proposition_4, required this.reponse, required this.seconds});

  // Mettre sous JSON
  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'id_test': id_test,
        'intitule': intitule,
        'proposition_1': proposition_1,
        'proposition_2': proposition_2,
        'proposition_3': proposition_3,
        'proposition_4': proposition_4,
        'reponse': reponse,
        'seconds': seconds,
      };

  // Mettre le JSON en donnée MongoDB (qui ne supporte que le JSON)
  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: (json['_id'] as ObjectId).toHexString(),
        id_test: json['id_test'] ?? '',
        intitule: json['intitule'] ?? '',
        proposition_1: json['proposition_1'] ?? '',
        proposition_2: json['proposition_2'] ?? '',
        proposition_3: json['proposition_3'] ?? '',
        proposition_4: json['proposition_4'] ?? '',
        reponse: json['reponse'] ?? 1,
        seconds: json['seconds'] ?? 60,
      );
}
