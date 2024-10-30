import 'dart:developer';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import "databaseService.dart";

class TestService {
  // Récupère tous les tests depuis la base de données
  static Future<List<Test>> getAllTests() async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final testsData = await MongoDatabase.test.find().toList();
      // Convertit les données JSON en objets Test
      return testsData.map((json) => Test.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching tests: ${e.toString()}'); // Log en cas d'erreur de récupération
      return [];
    }
  }

  // Crée un nouveau test dans la base de données
  static Future<String> createTest(Test testOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Vérifie la connexion

    try {
      final result = await MongoDatabase.test.insertOne(testOne.toJson());
      return result.isSuccess ? "Test créé avec succès" : "Erreur de création du test";
    } catch (e) {
      print('Error creating test: $e'); // Log en cas d'erreur de création
      return "Erreur de création du test";
    }
  }

  // Met à jour un test existant dans la base de données
  static Future<String> updateTest(Test testOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Assure la connexion

    try {
      final result = await MongoDatabase.test.updateOne(
        where.eq('_id', ObjectId.fromHexString(testOne.id)), // Recherche par ID unique
        modify.set('nom_discipline', testOne.nom_discipline), // Met à jour le nom de la discipline
      );
      return result.isSuccess ? "Test mis à jour avec succès" : "Erreur de mise à jour du test";
    } catch (e) {
      print('Error updating test: $e'); // Log en cas d'erreur de mise à jour
      return "Erreur de mise à jour du test";
    }
  }

  // Supprime un test de la base de données par ID
  static Future<String> deleteTest(String testId) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Assure la connexion

    try {
      final result = await MongoDatabase.test.deleteOne({'_id': ObjectId.fromHexString(testId)});
      return result.isSuccess ? "Test supprimé avec succès" : "Erreur de suppression du test";
    } catch (e) {
      print('Error deleting test: $e'); // Log en cas d'erreur de suppression
      return "Erreur de suppression du test";
    }
  }
}
