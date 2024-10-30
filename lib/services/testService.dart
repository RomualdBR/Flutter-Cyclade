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

class TestService {
  static Future<List<Test>> getAllTests() async {
    if (!await MongoDatabase.ensureConnection()) return [];

    try {
      final testsData = await MongoDatabase.test.find().toList();
      return testsData.map((json) => Test.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching tests: ${e.toString()}');
      return [];
    }
  }

  static Future<String> createTest(Test testOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect();
    try {
      final result = await MongoDatabase.test.insertOne(testOne.toJson());
      return result.isSuccess ? "Test créé avec succès" : "Erreur de création du test";
    } catch (e) {
      print('Error creating test: $e');
      return "Erreur de création du test";
    }
  }

  static Future<String> updateTest(Test testOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect();
    try {
      final result = await MongoDatabase.test.updateOne(
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
    if (MongoDatabase.db == null) await MongoDatabase.connect();
    try {
      final result = await MongoDatabase.test.deleteOne({'_id': ObjectId.fromHexString(testId)});
      return result.isSuccess ? "Test supprimé avec succès" : "Erreur de suppression du test";
    } catch (e) {
      print('Error deleting test: $e');
      return "Erreur de suppression du test";
    }
  }
}
