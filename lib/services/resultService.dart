import 'package:flutter_cyclade/models/resultatTestModel.dart';
import "databaseService.dart";

class ResultService {
  // Crée un nouveau résultat de test dans la base de données
  static Future<String> createResult(ResultatTest resultatTestOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Vérifie la connexion

    try {
      final result = await MongoDatabase.resultatTest.insertOne(resultatTestOne.toJson());
      return result.isSuccess
          ? "Résultat-test créé avec succès" // Message si l'insertion réussit
          : "Erreur de création du résultat-test"; // Message en cas d'erreur
    } catch (e) {
      print('Error creating resultat-test: $e'); // Log de l'erreur
      return "Erreur de création du resultat-test";
    }
  }
}
