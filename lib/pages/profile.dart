import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:flutter_cyclade/services/motivationService.dart';
import 'package:flutter_cyclade/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cyclade/motivationProvider.dart';


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
  List<Motivation> motivations = [];
  String _selectedMotivationId = userData.id_motivation;

  @override
  void initState() {
    super.initState();
    final motivationProvider = Provider.of<MotivationProvider>(context, listen: false);
    motivationProvider.loadMotivations(); // Charge les motivations
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final motivationProvider = Provider.of<MotivationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prénom :  ${userProvider.user.prenom}"),
            Text("nom : ${userProvider.user.nom}"),
            Text("email : ${userProvider.user.email}"),
            Text("age : ${userProvider.user.age}"),
            Text("adresse : ${userProvider.user.adresse}"),
            Text("motivation : ${userProvider.user.id_motivation} "),
            if (userData.role == true)
              Text("Rôle : ${userProvider.user.role}"),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouvelle adresse"),
              initialValue: userProvider.user.adresse,
              onChanged: (value) {
                setState(() {
                  adresse = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouvelle email"),
              initialValue: userProvider.user.email,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouveau nom"),
              initialValue: userProvider.user.nom,
              onChanged: (value) {
                setState(() {
                  nom = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nouveau prenom"),
              initialValue: userProvider.user.prenom,
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Motivation'),
              value: _selectedMotivationId,
              items: motivationProvider.motivations.map((motivation) {
                return DropdownMenuItem<String>(
                  value: motivation.id, // Utilise l'ID de la motivation
                  child: Text(motivation.nom), // Affiche le nom de la motivation
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMotivationId = value!; // Met à jour l'ID de motivation sélectionné
                });
              },
              onSaved: (value) => _selectedMotivationId = value!, // Sauvegarde la valeur sélectionnée
              validator: (value) => value == null || value.isEmpty
                  ? 'Veuillez sélectionner une motivation'
                  : null,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  final updatedUser = User(
                    id: userProvider.user.id,
                    prenom: prenom,
                    nom: nom,
                    email: email,
                    age: userData.age,
                    adresse: adresse,
                    role: userProvider.user.role,
                    id_motivation: _selectedMotivationId,
                    mot_de_passe: userProvider.user.mot_de_passe,
                  );

                  await userProvider.updateUser(updatedUser);
                }
              },
              child: const Text("Mettre à jour"),
            ),
            if (userProvider.formErrorText.isNotEmpty)
              Text(
                userProvider.formErrorText,
                style: TextStyle(color: Colors.red),
              ),
            if (userData.id != "0")
              ElevatedButton(
                onPressed: userProvider.disconnectUser,
                child: const Text("Se déconnecter"),
              ),
          ],
        ),
      ),
    );
  }
}
