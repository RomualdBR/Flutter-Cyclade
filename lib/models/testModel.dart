import 'package:mongo_dart/mongo_dart.dart';

class Test {
  final String id;
  final String nom_discipline;

  Test({required this.id, required this.nom_discipline});

  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'nom_discipline': nom_discipline,
      };

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: (json['_id'] as ObjectId).toHexString(),
        nom_discipline: json['nom_discipline'] ?? '',
      );

  @override
  String toString() => 'Test(id: $id, nom_discipline: $nom_discipline)';
}
