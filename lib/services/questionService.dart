import 'dart:developer';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import "databaseService.dart";

class QuestionService {
  // Crée une nouvelle question dans la base de données
  static Future<String> createQuestion(Question questionOne) async {
    if (!await MongoDatabase.ensureConnection()) return "Connection error"; // Vérifie la connexion

    try {
      var result = await MongoDatabase.question.insertOne(questionOne.toJson());
      return result.isSuccess ? "Question créée avec succès" : "Erreur de création de la question";
    } catch (e) {
      log('Error creating question: ${e.toString()}');
      return "Erreur de création de la question";
    }
  }

  // Récupère toutes les questions liées à un test donné
  static Future<List<Question>> getQuestionsByTestId(String testId) async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final questionsData = await MongoDatabase.question.find({'id_test': testId}).toList();
      // Convertit chaque élément JSON en objet Question
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching questions for test $testId: ${e.toString()}');
      return [];
    }
  }

  // Met à jour une question existante dans la base de données
  static Future<String> updateQuestion(Question questionOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Assure que la connexion est établie

    try {
      final result = await MongoDatabase.question.updateOne(
        where.eq('_id', ObjectId.fromHexString(questionOne.id)), // Recherche par ID unique
        modify
            .set('intitule', questionOne.intitule) // Mise à jour des champs de la question
            .set('proposition_1', questionOne.proposition_1)
            .set('proposition_2', questionOne.proposition_2)
            .set('proposition_3', questionOne.proposition_3)
            .set('proposition_4', questionOne.proposition_4)
            .set('reponse', questionOne.reponse)
            .set('seconds', questionOne.seconds),
      );
      return result.isSuccess ? "Question mise à jour avec succès" : "Erreur de mise à jour de la question";
    } catch (e) {
      print('Error updating question: $e');
      return "Erreur de mise à jour de la question";
    }
  }

  // Supprime une question de la base de données
  static Future<String> deleteQuestion(String questionId) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect(); // Assure la connexion

    try {
      final result = await MongoDatabase.question.deleteOne({'_id': ObjectId.fromHexString(questionId)});
      return result.isSuccess ? "Question supprimée avec succès" : "Erreur de suppression de la question";
    } catch (e) {
      print('Error deleting question: $e');
      return "Erreur de suppression de la question";
    }
  }
}
