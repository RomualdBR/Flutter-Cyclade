import 'dart:developer';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'databaseService.dart';

class QuestionService {
  // Crée une nouvelle question dans la base de données
  static Future<String> createQuestion(Question question) async {
    if (!await MongoDatabase.ensureConnection()) return "Erreur de connexion à la base de données"; // Vérifie la connexion

    try {
      var result = await MongoDatabase.question.insertOne(question.toJson());
      return result.isSuccess ? "Question créée avec succès" : "Erreur lors de la création de la question";
    } catch (e) {
      log('Erreur lors de la création de la question: ${e.toString()}');
      return "Erreur lors de la création de la question";
    }
  }

  // Récupère toutes les questions liées à un test donné
  static Future<List<Question>> getQuestionsByTestId(String testId) async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final questionsData = await MongoDatabase.question.find({'id_test': testId}).toList();
      // Convertit chaque document JSON en objet Question
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      log('Erreur lors de la récupération des questions pour le test $testId: ${e.toString()}');
      return [];
    }
  }

  // Met à jour une question existante dans la base de données
  static Future<String> updateQuestion(Question question) async {
    if (!await MongoDatabase.ensureConnection()) return "Erreur de connexion à la base de données"; // Vérifie la connexion

    try {
      final result = await MongoDatabase.question.updateOne(
        where.eq('_id', ObjectId.fromHexString(question.id)), // Recherche par ID unique
        modify
            .set('intitule', question.intitule)
            .set('proposition_1', question.proposition_1)
            .set('proposition_2', question.proposition_2)
            .set('proposition_3', question.proposition_3)
            .set('proposition_4', question.proposition_4)
            .set('reponse', question.reponse)
            .set('seconds', question.seconds),
      );
      return result.isSuccess ? "Question mise à jour avec succès" : "Erreur lors de la mise à jour de la question";
    } catch (e) {
      log('Erreur lors de la mise à jour de la question: $e');
      return "Erreur lors de la mise à jour de la question";
    }
  }

  // Supprime une question de la base de données
  static Future<String> deleteQuestion(String questionId) async {
    if (!await MongoDatabase.ensureConnection()) return "Erreur de connexion à la base de données"; // Vérifie la connexion

    try {
      final result = await MongoDatabase.question.deleteOne({'_id': ObjectId.fromHexString(questionId)});
      return result.isSuccess ? "Question supprimée avec succès" : "Erreur lors de la suppression de la question";
    } catch (e) {
      log('Erreur lors de la suppression de la question: $e');
      return "Erreur lors de la suppression de la question";
    }
  }
}
