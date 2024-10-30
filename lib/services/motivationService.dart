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

class MotivationService {
  static Future<List<Motivation>> getAllMotivations() async {
    if (!await MongoDatabase.ensureConnection()) return [];

    try {
      final motivationsData = await MongoDatabase.motivation.find().toList();
      return motivationsData.map((json) => Motivation.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching motivations: ${e.toString()}');
      return [];
    }
  }

  static Future<void> createDefaultMotivations() async {
    if (!await MongoDatabase.ensureConnection()) return;

    try {
      List<Motivation> defaultMotivations = [
        Motivation(id: ObjectId().toHexString(), nom: 'Poursuite d’étude'),
        Motivation(id: ObjectId().toHexString(), nom: 'Reconversion pro'),
        Motivation(id: ObjectId().toHexString(), nom: 'Réorientation'),
      ];

      // Vérifiez si les motivations existent déjà
      for (var motivationOne in defaultMotivations) {
        var existingMotivation = await MongoDatabase.motivation.findOne({'nom': motivationOne.nom});
        if (existingMotivation == null) {
          await MongoDatabase.motivation.insertOne(motivationOne.toJson());
        }
      }
    } catch (e) {
      log('Error creating default motivations: ${e.toString()}');
    }
  }
}
