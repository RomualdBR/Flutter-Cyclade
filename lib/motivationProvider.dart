import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:flutter_cyclade/services/motivationService.dart';

class MotivationProvider extends ChangeNotifier {
  List<Motivation> _motivations = [];

  List<Motivation> get motivations => _motivations;

  Future<void> loadMotivations() async {
    try {
      _motivations = await MotivationService.getAllMotivations();
      notifyListeners(); // Notifie les changements pour les mises à jour automatiques
    } catch (e) {
      // Gérer les erreurs de chargement
      print("Erreur lors du chargement des motivations: $e");
    }
  }

  void updateMotivation(String newMotivationId) {
    // Fonction pour mettre à jour la motivation sélectionnée si nécessaire
    // Tu peux ajouter ici d'autres fonctionnalités pour gérer la motivation sélectionnée
    notifyListeners();
  }
}