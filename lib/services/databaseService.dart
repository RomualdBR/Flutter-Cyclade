import 'dart:developer';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
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

  // 3 services pour les graph
  static Future<List<ResultatTest>> getAllScores() async {
  if (!await ensureConnection()) return [];

  try {
    final scoresData = await resultatTest.find().toList();
    return scoresData.map((json) => ResultatTest.fromJson(json)).toList();
  } catch (e) {
    log('Erreur Fatal de récupération des scores: ${e.toString()}');
    return [];
  }
}

Future<double> calculerTauxReussiteGeneral() async {
  List<ResultatTest> resultats = await MongoDatabase.getAllScores();

  if (resultats.isEmpty) {
    log("Aucun score trouvé dans la base de données");
    return 0.0;
  }

  double sommeScores = resultats.fold(0, (somme, resultat) => somme + resultat.score.toDouble());
  double tauxReussite = sommeScores / resultats.length;

  log("Taux de réussite calculé: $tauxReussite");
  return tauxReussite;
}


Future<Map<String, double>> calculerScoresParDate() async {
  List<ResultatTest> resultats = await MongoDatabase.getAllScores();

  Map<String, List<double>> scoresParDate = {};
  
  for (var resultat in resultats) {
    String mois = "${resultat.date.year}";
    // -${resultat.date.month.toString().padLeft(2, '0')}
    if (!scoresParDate.containsKey(mois)) {
      scoresParDate[mois] = [];
    }
    scoresParDate[mois]!.add(resultat.score.toDouble());
  }

  Map<String, double> moyenneScoresParDate = {};
  scoresParDate.forEach((mois, scores) {
    moyenneScoresParDate[mois] = scores.reduce((a, b) => a + b) / scores.length;
  });

  return moyenneScoresParDate;
}

  

  
}
