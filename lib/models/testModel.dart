import 'package:mongo_dart/mongo_dart.dart';

// Modèle de la table "test", gère la structure de la table
class Test {
  // Définit les élements de la table
  final String id;
  final String nom_discipline;

  // Le constructeur
  Test({required this.id, required this.nom_discipline});

  // Mettre sous JSON
  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'nom_discipline': nom_discipline,
      };

  // Mettre le JSON en donnée MongoDB (qui ne supporte que le JSON)
  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: (json['_id'] as ObjectId).toHexString(),
        nom_discipline: json['nom_discipline'] ?? '',
      );

  @override
  String toString() => 'Test(id: $id, nom_discipline: $nom_discipline)';
}
