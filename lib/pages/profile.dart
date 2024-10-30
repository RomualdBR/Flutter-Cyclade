import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/userModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  String prenom = userData.prenom.toString();
  String nom = userData.nom.toString();
  String email = userData.email.toString();
  String adresse = userData.adresse.toString();
  String formErrorText = "";

  Future<void> _updateUser() async {
    print("Ma fonction updateUser");
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final updateUser = User(
        id: userData.id.toString(),
        prenom: prenom,
        nom: nom,
        email: email,
        age: userData.age,
        adresse: adresse,
        role: userData.role,
        id_motivation: userData.id_motivation,
        mot_de_passe: userData.mot_de_passe,
      );
      try {
        var result = await MongoDatabase.update(updateUser);
        if (result != null) {
          userData = updateUser;
        }
      } catch (e) {
        print("Failed to update user: $e");
        setState(() {
          formErrorText = "Failed to update";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prénom : " + userData.prenom.toString()),
            Text("nom : " + userData.nom.toString()),
            Text("email : " + userData.email.toString()),
            Text("age : " + userData.age.toString()),
            Text("adresse : " + userData.adresse.toString()),
            Text("motivation : " + userData.id_motivation.toString()),
            if (userData.role == true)
              Text("Rôle : " + userData.role.toString()),

            TextFormField(
              decoration: const InputDecoration(labelText: "Nouvelle adresse"),
              initialValue: adresse,
              onChanged: (value) {
                setState(() {
                  adresse = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouvelle email"),
              initialValue: email,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouveau nom"),
              initialValue: nom,
              onChanged: (value) {
                setState(() {
                  nom = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouveau prenom"),
              initialValue: prenom,
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
            ),

            ElevatedButton(
              onPressed: _updateUser,
              child: const Text("Mettre à jour"),
            ),
            if (formErrorText.isNotEmpty)
              Text(
                formErrorText,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
