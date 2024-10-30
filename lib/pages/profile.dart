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
  final _formkey = GlobalKey<FormState>(); // Clé pour la validation du formulaire
  String prenom = userData.prenom.toString(); // Variables pour les données du profil utilisateur
  String nom = userData.nom.toString();
  String email = userData.email.toString();
  String adresse = userData.adresse.toString();
  String formErrorText = ""; // Message d'erreur à afficher sous le formulaire

  void _disconnectUser() async {
    if (userData.id != "0") {
      // Déconnexion de l'utilisateur en réinitialisant les données utilisateur
      userData = User(
          id: "0",
          nom: "nom",
          prenom: "prenom",
          email: "email",
          age: 0,
          adresse: "adresse",
          role: false,
          id_motivation: "0",
          mot_de_passe: "mot_de_passe");
      Navigator.pushReplacementNamed(context, '/'); // Redirection vers l'accueil après déconnexion
    }
  }

  Future<void> _updateUser() async {
    if (_formkey.currentState!.validate()) { // Vérifie la validité du formulaire
      _formkey.currentState!.save(); // Sauvegarde les données mises à jour dans le formulaire
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
        var result = await MongoDatabase.update(updateUser); // Envoie les données mises à jour à la base de données
        if (result != null) {
          userData = updateUser; // Met à jour les informations utilisateur dans l'application
        }
      } catch (e) {
        // Gestion de l'erreur d'échec de mise à jour
        print("Failed to update user: $e");
        setState(() {
          formErrorText = "Failed to update";
        });
      }
    }
  }

  // Construction de la page de profil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage des informations utilisateur actuelles
            Text("Prénom : " + userData.prenom.toString()),
            Text("Nom : " + userData.nom.toString()),
            Text("Email : " + userData.email.toString()),
            Text("Age : " + userData.age.toString()),
            Text("Adresse : " + userData.adresse.toString()),
            Text("Motivation : " + userData.id_motivation.toString()),
            if (userData.role == true) Text("Rôle : " + userData.role.toString()),
            
            // Champs pour modifier les informations utilisateur
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
              decoration: const InputDecoration(labelText: "Nouvel email"),
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
              decoration: const InputDecoration(labelText: "Nouveau prénom"),
              initialValue: prenom,
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
            ),
            
            // Bouton pour mettre à jour les informations utilisateur
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text("Mettre à jour"),
            ),
            
            // Message d'erreur si la mise à jour échoue
            if (formErrorText.isNotEmpty)
              Text(
                formErrorText,
                style: TextStyle(color: Colors.red),
              ),
            
            // Bouton pour se déconnecter si l'utilisateur est connecté
            if (userData.id != "0")
              ElevatedButton(
                onPressed: _disconnectUser,
                child: const Text("Se déconnecter"),
              ),
          ],
        ),
      ),
    );
  }
}
