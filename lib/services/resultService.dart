import 'package:flutter_cyclade/models/resultatTestModel.dart';
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
