import 'dart:developer';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import "databaseService.dart";

class QuestionService {
  static Future<String> createQuestion(Question questionOne) async {
    if (!await MongoDatabase.ensureConnection()) return "Connection error";

    try {
      var result = await MongoDatabase.question.insertOne(questionOne.toJson());
      return result.isSuccess ? "Question créée avec succès" : "Erreur de création de la question";
    } catch (e) {
      log('Error creating question: ${e.toString()}');
      return "Erreur de création de la question";
    }
  }

   static Future<List<Question>> getQuestionsByTestId(String testId) async {
    if (!await MongoDatabase.ensureConnection()) return [];

    try {
      final questionsData = await MongoDatabase.question.find({'id_test': testId}).toList();
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching questions for test $testId: ${e.toString()}');
      return [];
    }
  }

  static Future<String> updateQuestion(Question questionOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect();

    try {
      final result = await MongoDatabase.question.updateOne(
        where.eq('_id', ObjectId.fromHexString(questionOne.id)),
        modify
            .set('intitule', questionOne.intitule)
            .set('proposition_1', questionOne.proposition_1)
            .set('proposition_2', questionOne.proposition_2)
            .set('proposition_3', questionOne.proposition_3)
            .set('proposition_4', questionOne.proposition_4)
            .set('reponse', questionOne.reponse),
      );
      return result.isSuccess ? "Question mise à jour avec succès" : "Erreur de mise à jour de la question";
    } catch (e) {
      print('Error updating question: $e');
      return "Erreur de mise à jour de la question";
    }
  }

  static Future<String> deleteQuestion(String questionId) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect();

    try {
      final result = await MongoDatabase.question.deleteOne({'_id': ObjectId.fromHexString(questionId)});
      return result.isSuccess ? "Question supprimée avec succès" : "Erreur de suppression de la question";
    } catch (e) {
      print('Error deleting question: $e');
      return "Erreur de suppression de la question";
    }
  }
}
