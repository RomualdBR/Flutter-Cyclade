import 'package:mongo_dart/mongo_dart.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final int age;
  final String adresse;
  final bool role;
  final String id_motivation;

  User({required this.id, required this.nom, required this.prenom, required this.email, required this.age, required this.adresse, required this.role, required this.id_motivation});

  Map<String, dynamic> toJson() => {
        '_id': ObjectId.fromHexString(id),
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'age': age,
        'adresse': adresse,
        'role': role,
        'id_motivation': id_motivation,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['_id'] as ObjectId).toHexString(),
        nom: json['nom'] ?? '',
        prenom: json['prenom'] ?? '',
        email: json['email'] ?? '',
        age: json['age'] ?? 0,
        adresse: json['adresse'] ?? '',
        role: json['role'] ?? false,
        id_motivation: json['id_motivation'] ?? '',
      );
}
