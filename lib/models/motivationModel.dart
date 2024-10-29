import 'package:mongo_dart/mongo_dart.dart';

class Motivation {
  final String id;
  final String nom;

  Motivation({required this.id, required this.nom});

  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'nom': nom,
      };

  factory Motivation.fromJson(Map<String, dynamic> json) => Motivation(
        id: (json['_id'] as ObjectId).toHexString(),
        nom: json['nom'] ?? '',
      );
}
