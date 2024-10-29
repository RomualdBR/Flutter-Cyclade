import 'dart:developer';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
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
}
