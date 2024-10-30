import 'dart:developer';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import "databaseService.dart";

class MotivationService {
  // Récupère toutes les motivations depuis la base de données
  static Future<List<Motivation>> getAllMotivations() async {
    if (!await MongoDatabase.ensureConnection()) return []; // Vérifie la connexion

    try {
      final motivationsData = await MongoDatabase.motivation.find().toList();
      // Convertit les données JSON en objets Motivation
      return motivationsData.map((json) => Motivation.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching motivations: ${e.toString()}');
      return []; // Renvoie une liste vide en cas d’erreur
    }
  }

  // Crée les motivations par défaut si elles n'existent pas encore
  static Future<void> createDefaultMotivations() async {
    if (!await MongoDatabase.ensureConnection()) return;

    try {
      List<Motivation> defaultMotivations = [
        Motivation(id: ObjectId().toHexString(), nom: 'Poursuite d’étude'),
        Motivation(id: ObjectId().toHexString(), nom: 'Reconversion pro'),
        Motivation(id: ObjectId().toHexString(), nom: 'Réorientation'),
      ];

      // Pour chaque motivation par défaut, vérifier si elle existe déjà
      for (var motivationOne in defaultMotivations) {
        var existingMotivation = await MongoDatabase.motivation.findOne({'nom': motivationOne.nom});
        if (existingMotivation == null) {
          // Insère la motivation si elle n'existe pas encore dans la base
          await MongoDatabase.motivation.insertOne(motivationOne.toJson());
        }
      }
    } catch (e) {
      log('Error creating default motivations: ${e.toString()}'); // Log en cas d'erreur
    }
  }
}
