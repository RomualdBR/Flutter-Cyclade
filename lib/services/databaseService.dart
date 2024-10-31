import 'dart:developer';
import 'dart:convert';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:crypto/crypto.dart';
import '../constant.dart';

class MongoDatabase {
  static Db? _db;
  static late DbCollection user;
  static late DbCollection test;
  static late DbCollection question;
  static late DbCollection resultatTest;
  static late DbCollection motivation;
  static bool _isInitialized = false;

  static Db? get db => _db;

  static Future<void> connect() async {
    if (_isInitialized) return;

    try {
      _db = await Db.create(MONGO_CONN_URL);
      await _db!.open();
      inspect(_db);

      // Initialisation des collections
      user = _db!.collection(USER_COLLECTION);
      test = _db!.collection(TEST_COLLECTION);
      question = _db!.collection(QUESTION_COLLECTION);
      resultatTest = _db!.collection(RESULTAT_TEST_COLLECTION);
      motivation = _db!.collection(MOTIVATION_COLLECTION);

      _isInitialized = true;
    } catch (e) {
      log('Erreur de connexion à la base de données: ${e.toString()}');
    }
  }

  static Future<void> close() async {
    try {
      await _db?.close();
      _isInitialized = false;
    } catch (e) {
      log('Erreur lors de la fermeture de la connexion: ${e.toString()}');
    }
  }

  static Future<bool> ensureConnection() async {
    if (!_isInitialized) await connect();
    return _isInitialized;
  }

  static Future<String> update(User userData) async {
    try {
      var result = await user.updateOne(
          where.eq('_id', ObjectId.fromHexString(userData.id)),
          modify
              .set('prenom', userData.prenom)
              .set('nom', userData.nom)
              .set('email', userData.email)
              .set('adresse', userData.adresse));
      return result.isAcknowledged ? "Mise à jour réussie" : "Échec de la mise à jour";
    } catch (e) {
      return "Erreur de mise à jour: ${e.toString()}";
    }
  }

  static Future<bool> emailExists(String email) async {
    if (!await ensureConnection()) return false;
    try {
      var existingUser = await user.findOne({'email': email});
      return existingUser != null;
    } catch (e) {
      log('Erreur lors de la vérification de l\'email: ${e.toString()}');
      return false;
    }
  }

  static Future<String> insert(User userData) async {
    if (!await ensureConnection()) return "Erreur de connexion";
    try {
      var result = await user.insertOne(userData.toJson());
      return result.isSuccess ? "Insertion réussie" : "Échec de l'insertion";
    } catch (e) {
      log('Erreur lors de l\'insertion: ${e.toString()}');
      return "Erreur d'insertion";
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
      log('Erreur d\'authentification: ${e.toString()}');
      return null;
    }
  }


  // Récupère tous les scores de tests
  static Future<List<ResultatTest>> getAllScores() async {
    if (!await ensureConnection()) return [];
    try {
      final scoresData = await resultatTest.find().toList();
      return scoresData.map((json) => ResultatTest.fromJson(json)).toList();
    } catch (e) {
      log('Erreur de récupération des scores: ${e.toString()}');
      return [];
    }
  }

  static Future<List<ResultatTest>> getAllScoresByTest(String testId) async {
    if (!await ensureConnection()) return [];
    try {
      final scoresData = await resultatTest.find({'id_test': testId}).toList();
      return scoresData.map((json) => ResultatTest.fromJson(json)).toList();
    } catch (e) {
      log('Erreur de récupération des scores pour le test $testId: ${e.toString()}');
      return [];
    }
  }

  Future<double> calculerTauxReussiteGeneral() async {
    List<ResultatTest> resultats = await getAllScores();
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
    List<ResultatTest> resultats = await getAllScores();

    Map<String, List<double>> scoresParDate = {};
    for (var resultat in resultats) {
      String mois = "${resultat.date.year}";
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

  static Future<List<Map<String, dynamic>>> getPassedTests() async {
    if (!await ensureConnection()) return [];

    try {
      final results = await resultatTest.find().toList();
      List<Map<String, dynamic>> resultList = [];

      for (var result in results) {
        var userDetails = await user.findOne({'_id': ObjectId.fromHexString(result['id_user'])});
        var testDetails = await test.findOne({'_id': ObjectId.fromHexString(result['id_test'])});

        // Récupérer le nombre de questions pour le test
        var questionCount = await question.count(where.eq('id_test', result['id_test']));

        if (userDetails != null && testDetails != null) {
          resultList.add({
            'user_name': userDetails['nom'],
            'test_name': testDetails['nom_discipline'],
            'date': result['date'],
            'score': result['score'],
            'question_count': questionCount, // Ajoutez le nombre de questions
          });
        }
      }

      return resultList;
    } catch (e) {
      log('Erreur lors de la récupération des tests passés: ${e.toString()}');
      return [];
    }
  }

}
