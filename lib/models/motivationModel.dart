import 'package:mongo_dart/mongo_dart.dart';

// Modèle de la table "motivation", gère la structure de la table
class Motivation {
  // Définit les élements de la table
  final String id;
  final String nom;

  // Le constructeur
  Motivation({required this.id, required this.nom});

  // Mettre sous JSON
  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'nom': nom,
      };

  // Mettre le JSON en donnée MongoDB (qui ne supporte que le JSON)
  factory Motivation.fromJson(Map<String, dynamic> json) => Motivation(
        id: (json['_id'] as ObjectId).toHexString(),
        nom: json['nom'] ?? '',
      );
}
