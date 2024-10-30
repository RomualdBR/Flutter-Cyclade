import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

class UserProvider extends ChangeNotifier {
  User _user = userData;
  String formErrorText = "";

  User get user => _user;

  Future<void> updateUser(User updatedUser) async {
    try {
      var result = await MongoDatabase.update(updatedUser);
      if (result == "success") {
        _user = updatedUser;
        formErrorText = "";
        notifyListeners();
      } else {
        formErrorText = "Failed to update";
      }
    } catch (e) {
      formErrorText = "Failed to update";
    }
  }

  void disconnectUser() {
    _user = User(
      id: "0",
      nom: "nom",
      prenom: "prenom",
      email: "email",
      age: 0,
      adresse: "adresse",
      role: false,
      id_motivation: "0",
      mot_de_passe: "mot_de_passe",
    );
    notifyListeners();
  }
}
