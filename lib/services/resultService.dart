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

class ResultService {
  static Future<String> createResult(ResultatTest resultatTestOne) async {
    if (MongoDatabase.db == null) await MongoDatabase.connect();
    try {
      final result = await MongoDatabase.resultatTest.insertOne(resultatTestOne.toJson());
      return result.isSuccess
          ? "Résultat-test créé avec succès"
          : "Erreur de création du résultat-test";
    } catch (e) {
      print('Error creating resultat-test: $e');
      return "Erreur de création du resultat-test";
    }
  }
}
