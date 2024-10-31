import 'dart:developer';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class MongoDatabase {
  static Db? _db; // Instance de la base de données
  static late DbCollection user; // Collection pour les utilisateurs
  static late DbCollection test; // Collection pour les tests
  static late DbCollection question; // Collection pour les questions
  static late DbCollection resultatTest; // Collection pour les résultats de tests
  static late DbCollection motivation; // Collection pour les motivations
  static bool _isInitialized = false; // Indique si la connexion est établie

  static Db? get db => _db;

  static set db(Db? value) {
    _db = value;
  }

  // Connexion à la base de données
  static Future<void> connect() async {
    if (_isInitialized) return; // Empêche les connexions multiples

    try {
      _db = await Db.create(MONGO_CONN_URL); // Initialisation avec URL
      await _db!.open();
      inspect(_db); // Outil d’inspection pour déboguer la connexion

      // Initialisation des collections
      user = _db!.collection(USER_COLLECTION);
      test = _db!.collection(TEST_COLLECTION);
      question = _db!.collection(QUESTION_COLLECTION);
      resultatTest = _db!.collection(RESULTAT_TEST_COLLECTION);
      motivation = _db!.collection(MOTIVATION_COLLECTION);

      _isInitialized = true; // Indique que la connexion est active
    } catch (e) {
      log('Connection error: ${e.toString()}'); // Log en cas d'erreur de connexion
    }
  }

  // Fermeture de la connexion
  static Future<void> close() async {
    try {
      await _db?.close();
      _isInitialized = false;
    } catch (e) {
      log('Close connection error: ${e.toString()}');
    }
  }

  // Assure que la connexion est établie avant d'exécuter une opération
  static Future<bool> ensureConnection() async {
    if (!_isInitialized) await connect();
    return _isInitialized;
  }

  // Mise à jour des informations utilisateur
  static Future<String> update(User userData) async {
    try {
      var result = await user.updateOne(
          where.eq('_id', ObjectId.fromHexString(userData.id)), // Recherche par ID
          modify
              .set('prenom', userData.prenom)
              .set('nom', userData.nom)
              .set('email', userData.email)
              .set('adresse', userData.adresse)); // Mise à jour des champs
      return result.isAcknowledged ? "success" : "Update not acknowledged";
    } catch (e) {
      return "Update error: ${e.toString()}";
    }
  }

  // Vérifie si un email est déjà utilisé
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

  // Insère un nouvel utilisateur dans la base de données
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

  // Chiffrement du mot de passe avec SHA-256
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Authentification utilisateur par email et mot de passe
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

  // Récupère tous les scores de tests
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

  // Récupère les scores d'un test spécifique
  static Future<List<ResultatTest>> getAllScoresByTest(String testId) async {
    if (!await ensureConnection()) return [];
    try {
      final scoresData = await resultatTest.find({'id_test': testId}).toList();
      return scoresData.map((json) => ResultatTest.fromJson(json)).toList();
    } catch (e) {
      log('Erreur Fatal de récupération des scores: ${e.toString()}');
      return [];
    }
  }

  // Calcule le taux de réussite global de tous les tests
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

  // Calcule la moyenne des scores par mois
  Future<Map<String, double>> calculerScoresParDate() async {
    List<ResultatTest> resultats = await MongoDatabase.getAllScores();

    Map<String, List<double>> scoresParDate = {};
    for (var resultat in resultats) {
      String mois = "${resultat.date.year}"; // Mois dans le format "année"
      if (!scoresParDate.containsKey(mois)) {
        scoresParDate[mois] = [];
      }
      scoresParDate[mois]!.add(resultat.score.toDouble());
    }

    // Calcul de la moyenne des scores pour chaque mois
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
      log('Error fetching passed tests: ${e.toString()}');
      return [];
    }
  }

}
