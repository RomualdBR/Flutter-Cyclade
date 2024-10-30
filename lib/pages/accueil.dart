import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/userProvider.dart';
import 'package:provider/provider.dart';


// Classe représentant la page d'accueil, Stateful pour gérer l'état dynamique
class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _MyHomePageState();
}

// État associé à la page d'accueil
class _MyHomePageState extends State<AccueilPage> {
  // Fonctions de navigation pour les boutons
  void onPressed() {
    Navigator.pushNamed(context, '/inscription'); // Navigue vers la page d'inscription
  }

  void connexion() {
    Navigator.pushNamed(context, '/connexion'); // Navigue vers la page de connexion
  }

  void profile() {
    Navigator.pushNamed(context, '/profile'); // Navigue vers la page du profil utilisateur
  }

  void evaluations() {
    Navigator.pushNamed(context, '/evaluations'); // Navigue vers la page des évaluations
  }

  void resultats() {
    Navigator.pushNamed(context, '/resultats'); // Navigue vers la page des résultats
  }

  void graphiques() {
    Navigator.pushNamed(context, '/graphiques'); // Navigue vers la page des graphiques
  }

  void admin() {
    Navigator.pushNamed(context, '/admin'); // Navigue vers la page d'administration (accessible seulement si admin)
  }

  // Construction de la page d'accueil
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"), // Titre de la barre d'application
        automaticallyImplyLeading: false, // Retire le bouton de retour par défaut
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement des éléments en début de colonne
        children: [
          Text(userProvider.user.id.toString()),
          Text("Nom: " + userProvider.user.nom.toString()),
          Text("Prénom: " + userProvider.user.prenom.toString()),
          Text("Email: " + userProvider.user.email.toString()),

          // Boutons "Inscription" et "Connexion" visibles uniquement si l'utilisateur est non connecté (id=0)
          if (userProvider.user.id.toString() == "0")
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Inscription"), // Bouton pour s'inscrire
            ),
            ElevatedButton(
              onPressed: connexion,
              child: const Text("Connexion"), // Bouton pour se connecter
            ),
            ElevatedButton(
              onPressed: profile,
              child: const Text("Profile"),
            ),
            ElevatedButton(
              onPressed: evaluations,
              child: const Text("Evaluations"),
            ),
          

          // Bouton "Panel Admin" visible uniquement si l'utilisateur est admin
          if (userProvider.user.role == true)
            ElevatedButton(
              onPressed: admin,
              child: const Text("Panel Admin"), // Accès au panneau admin pour les administrateurs
            ),
        ],
      ),
    );
  }
}
