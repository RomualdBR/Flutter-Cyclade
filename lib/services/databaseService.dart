// file path: services/databaseService.dart
import 'dart:developer';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';

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
      _db = await Db.create(MONGO_CONN_URL);
      await _db!.open();
      inspect(_db);

      user = _db!.collection(USER_COLLECTION);
      test = _db!.collection(TEST_COLLECTION);
      question = _db!.collection(QUESTION_COLLECTION);
      resultatTest = _db!.collection(RESULTAT_TEST_COLLECTION);
      motivation = _db!.collection(MOTIVATION_COLLECTION);

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

  static Future<bool> emailExists(String email) async {
    try {
      var existingUser = await user.findOne({'email': email});
      return existingUser != null;
    } catch (e) {
      log('Email check error: ${e.toString()}');
      return false;
    }
  }

  static Future<String> insert(User userData) async {
    if (!_isInitialized) await connect();

    try {
      var result = await user.insertOne(userData.toJson());
      return result.isSuccess ? "Insertion réussie" : "Insertion non réussie";
    } catch (e) {
      log('Insertion error: ${e.toString()}');
      return "Insertion error";
    }
  }
}
