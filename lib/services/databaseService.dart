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

class MongoDatabase {
  static Db? _db;
  static late DbCollection user;
  static late DbCollection test;
  static late DbCollection question;
  static late DbCollection resultatTest;
  static late DbCollection motivation;
  static bool _isInitialized = false;

  static Future<void> connect() async {
    if (_isInitialized) return;

    try {
      _db = await Db.create(
          MONGO_CONN_URL);
      await _db!.open();
      inspect(_db);

      user = _db!
          .collection(USER_COLLECTION);
      test = _db!
          .collection(TEST_COLLECTION);
      question = _db!.collection(
          QUESTION_COLLECTION);
      resultatTest = _db!.collection(
          RESULTAT_TEST_COLLECTION);
      motivation = _db!.collection(
          MOTIVATION_COLLECTION);

      _isInitialized = true;
    } catch (e) {
      log('Connection error: ${e.toString()}');
    }
  }

  static Future<void> close() async {
    try {
      await _db?.close();
      _isInitialized = false;
    } catch (e) {
      log('Close connection error: ${e.toString()}');
    }
  }

  // Ensures connection before using the user collection
  static Future<bool>
      ensureConnection() async {
    if (!_isInitialized)
      await connect();
    return _isInitialized;
  }

  static Future<bool> emailExists(
      String email) async {
    if (!await ensureConnection())
      return false;

    try {
      var existingUser = await user
          .findOne({'email': email});
      return existingUser != null;
    } catch (e) {
      log('Email check error: ${e.toString()}');
      return false;
    }
  }

  static Future<String> insert(
      User userData) async {
    if (!await ensureConnection())
      return "Connection error";

    try {
      var result = await user
          .insertOne(userData.toJson());
      return result.isSuccess
          ? "Insertion réussie"
          : "Insertion non réussie";
    } catch (e) {
      log('Insertion error: ${e.toString()}');
      return "Insertion error";
    }
  }

  static String encryptPassword(
      String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<User?> authenticateUser(
      String email,
      String mot_de_passe) async {
    if (!await ensureConnection())
      return null;

    try {
      var motDePasseCrypte =
          encryptPassword(mot_de_passe);
      var existingUser =
          await user.findOne({
        'email': email,
        'mot_de_passe': motDePasseCrypte
      });
      return existingUser != null
          ? User.fromJson(existingUser)
          : null;
    } catch (e) {
      log('Authentication error: ${e.toString()}');
      return null;
    }
  }

  static Future<List<Motivation>>
      getAllMotivations() async {
    if (!await ensureConnection())
      return [];

    try {
      final motivationsData =
          await motivation
              .find()
              .toList();
      return motivationsData
          .map((json) =>
              Motivation.fromJson(json))
          .toList();
    } catch (e) {
      log('Error fetching motivations: ${e.toString()}');
      return [];
    }
  }

  static Future<void> createDefaultMotivations() async {
    if (!await ensureConnection()) return;

    try {
      List<Motivation> defaultMotivations = [
        Motivation(id: ObjectId().toHexString(), nom: 'Poursuite d’étude'),
        Motivation(id: ObjectId().toHexString(), nom: 'Reconversion pro'),
        Motivation(id: ObjectId().toHexString(), nom: 'Réorientation'),
      ];

      // Vérifiez si les motivations existent déjà
      for (var motivationOne in defaultMotivations) {
        var existingMotivation = await motivation
            .findOne({'nom': motivationOne.nom});
        if (existingMotivation == null) {
          await motivation.insertOne(motivationOne.toJson());
        }
      }
    } catch (e) {
      log('Error creating default motivations: ${e.toString()}');
    }
  }


  static Future<String> createQuestion(Question questionOne) async {
    if (!await ensureConnection()) return "Connection error";

    try {
      var result = await question.insertOne(questionOne.toJson());
      return result.isSuccess ? "Question créée avec succès" : "Erreur de création de la question";
    } catch (e) {
      log('Error creating question: ${e.toString()}');
      return "Erreur de création de la question";
    }
  }

  static Future<List<Test>> getAllTests() async {
    if (!await ensureConnection()) return [];

    try {
      final testsData = await test.find().toList();
      return testsData.map((json) => Test.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching tests: ${e.toString()}');
      return [];
    }
  }

  static Future<List<Question>> getQuestionsByTestId(String testId) async {
    if (!await ensureConnection()) return [];

    try {
      final questionsData = await question.find({'id_test': testId}).toList();
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching questions for test $testId: ${e.toString()}');
      return [];
    }
  }

  static Future<String> updateQuestion(Question questionOne) async {
    if (_db == null) await connect();

    try {
      final result = await question.updateOne(
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
    if (_db == null) await connect();

    try {
      final result = await question.deleteOne({'_id': ObjectId.fromHexString(questionId)});
      return result.isSuccess ? "Question supprimée avec succès" : "Erreur de suppression de la question";
    } catch (e) {
      print('Error deleting question: $e');
      return "Erreur de suppression de la question";
    }
  }

  static Future<String> createTest(Test testOne) async {
    if (_db == null) await connect();
    try {
      final result = await test.insertOne(testOne.toJson());
      return result.isSuccess ? "Test créé avec succès" : "Erreur de création du test";
    } catch (e) {
      print('Error creating test: $e');
      return "Erreur de création du test";
    }
  }

  static Future<String> createResult(ResultatTest resultatTestOne) async {
    if (_db == null) await connect();
    try {
      final result = await resultatTest.insertOne(resultatTestOne.toJson());
      return result.isSuccess ? "Résultat-test créé avec succès" : "Erreur de création du résultat-test";
    } catch (e) {
      print('Error creating resultat-test: $e');
      return "Erreur de création du resultat-test";
    }
  }

  static Future<String> updateTest(Test testOne) async {
    if (_db == null) await connect();
    try {
      final result = await test.updateOne(
        where.eq('_id', ObjectId.fromHexString(testOne.id)),
        modify.set('nom_discipline', testOne.nom_discipline),
      );
      return result.isSuccess ? "Test mis à jour avec succès" : "Erreur de mise à jour du test";
    } catch (e) {
      print('Error updating test: $e');
      return "Erreur de mise à jour du test";
    }
  }

  static Future<String> deleteTest(String testId) async {
    if (_db == null) await connect();
    try {
      final result = await test.deleteOne({'_id': ObjectId.fromHexString(testId)});
      return result.isSuccess ? "Test supprimé avec succès" : "Erreur de suppression du test";
    } catch (e) {
      print('Error deleting test: $e');
      return "Erreur de suppression du test";
    }
  }

  static Future<List<Map<String, dynamic>>> getPassedTests() async {
  if (!await ensureConnection()) return [];

  try {
    final results = await resultatTest.find().toList();

    List<Map<String, dynamic>> resultList = [];
    for (var result in results) {
      var userDetails = await user.findOne({'_id': ObjectId.fromHexString(result['id_user'])});
      
      var testDetails = await test.findOne({'_id': ObjectId.fromHexString(result['id_test'])});

      if (userDetails != null && testDetails != null) {
        resultList.add({
          'user_name': userDetails['nom'],
          'test_name': testDetails['nom_discipline'],
          'date': result['date'],
          'score': result['score'],
        });
      }
    }

    return resultList;
  } catch (e) {
    log('Error fetching passed tests: ${e.toString()}');
    return [];
  }
  }
}
