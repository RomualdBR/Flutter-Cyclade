import 'dart:developer';
import 'package:flutter_cyclade/models/userModel.dart';
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

  static Db? get db => _db;

  static set db(Db? value) {
    _db = value;
  }

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

  static Future<bool> ensureConnection() async {
    if (!_isInitialized) await connect();
    return _isInitialized;
  }

  static Future<String> update(User userData) async {
    print("Ma fonction update");
    try {
      var result = await user.updateOne(
        where.eq('_id', ObjectId.fromHexString(userData.id)),  // Utilisation de _id
        modify
            .set('prenom', userData.prenom)
            .set('nom', userData.nom)
            .set('email', userData.email)
            .set('adresse', userData.adresse)
      );
      if (result.isAcknowledged) {
        print("succes");
        return "success";
      } else {
        print('update not ack');
        return "Update not acknowledged";
      }
    } catch (e) {
      print('error');
      return "Update error: ${e.toString()}";
    }
  }

  static Future<bool> emailExists(String email) async {
    if (!await ensureConnection()) return false;

    try {
      var existingUser = await user.findOne({'email': email});
      return existingUser != null;
    } catch (e) {
      log('Email check error: ${e.toString()}');
      return false;
    }
  }

  static Future<String> insert(User userData) async {
    if (!await ensureConnection()) return "Connection error";

    try {
      var result = await user.insertOne(userData.toJson());
      return result.isSuccess ? "Insertion réussie" : "Insertion non réussie";
    } catch (e) {
      log('Insertion error: ${e.toString()}');
      return "Insertion error";
    }
  }

  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<User?> authenticateUser(String email, String mot_de_passe) async {
    if (!await ensureConnection()) return null;

    try {
      var motDePasseCrypte = encryptPassword(mot_de_passe);
      var existingUser = await user.findOne({'email': email, 'mot_de_passe': motDePasseCrypte});
      return existingUser != null ? User.fromJson(existingUser) : null;
    } catch (e) {
      log('Authentication error: ${e.toString()}');
      return null;
    }
  }

  

  
}
