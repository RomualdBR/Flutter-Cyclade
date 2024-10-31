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

  static Future<List<ResultatTest>> getAllResults() async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final resultsData = await MongoDatabase.resultatTest.find().toList();
      // Convertit les données JSON en objets Test
      return resultsData.map((json) => ResultatTest.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching tests: ${e.toString()}'); // Log en cas d'erreur de récupération
      return [];
    }
  }

  static Future<List<ResultatTest>> getAllResultsByUserAndTest(String userId, String testId) async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final resultsData = await MongoDatabase.resultatTest.find({'id_test':testId,'id_user':userId}).toList();
      // Convertit les données JSON en objets Test
      return resultsData.map((json) => ResultatTest.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching tests: ${e.toString()}'); // Log en cas d'erreur de récupération
      return [];
    }
  }

}
