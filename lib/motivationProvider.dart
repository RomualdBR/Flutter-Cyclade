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
      print("Erreur lors du chargement des motivations: $e");
    }
  }

  void updateMotivation(String newMotivationId) {
    notifyListeners();
  }
}