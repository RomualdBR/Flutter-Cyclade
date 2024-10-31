import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/userModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cyclade/UserProvider.dart';
import 'package:flutter_cyclade/models/motivationModel.dart';
import 'package:flutter_cyclade/motivationProvider.dart';


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
  List<Motivation> motivations = [];
  String _selectedMotivationId = userData.id_motivation;

  @override
  void initState() {
    super.initState();
    // Charger les motivations au démarrage de la page
    Provider.of<MotivationProvider>(context, listen: false).loadMotivations();
  }

  // Construction de la page de profil
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
            // Affichage des informations utilisateur actuelles
            Text("Prénom : ${userProvider.user.prenom}"),
            Text("Nom : ${userProvider.user.nom}"),
            Text("Email : ${userProvider.user.email}"),
            Text("Adresse : ${userProvider.user.adresse}"),
            Text("Age : ${userProvider.user.age}"),
            Text("Motivation : ${userProvider.user.id_motivation}"),
            if (userData.role == true) Text("Rôle : " + userData.role.toString()),
            
            // Champs pour modifier les informations utilisateur
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
              decoration: const InputDecoration(labelText: "Nouvel email"),
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
              decoration: const InputDecoration(labelText: "Nouveau prénom"),
              initialValue: userProvider.user.prenom,
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
            ),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Motivation'),
              value: userData.id_motivation,
              items: motivationProvider.motivations.map((motivation) {
                return DropdownMenuItem<String>(
                  value: motivation.id,
                  child: Text(motivation.nom),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedMotivationId = value!),
              validator: (value) => value == null || value.isEmpty
                  ? 'Veuillez sélectionner une motivation'
                  : null,
            ),
            
            // Bouton pour mettre à jour les informations utilisateur
            ElevatedButton(
              onPressed: () {
                final updatedUser = User(
                  id: userProvider.user.id,
                  nom: nom,
                  prenom: prenom,
                  email: email,
                  adresse: adresse,
                  age: userProvider.user.age,
                  role: userProvider.user.role,
                  id_motivation: _selectedMotivationId,
                  mot_de_passe: userProvider.user.mot_de_passe,
                );
                userProvider.updateUser(updatedUser);
              },
              child: const Text("Mettre à jour"),
            ),
            
            // Message d'erreur si la mise à jour échoue
            if (formErrorText.isNotEmpty)
              Text(
                formErrorText,
                style: TextStyle(color: Colors.red),
              ),
            
            // Bouton pour se déconnecter si l'utilisateur est connecté
            ElevatedButton(
              onPressed: () => userProvider.disconnectUser(),
              child: const Text("Se déconnecter"),
            ),
          ],
        ),
      ),
    );
  }
}
