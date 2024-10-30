import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"), // Titre de la barre d'application
        automaticallyImplyLeading: false, // Retire le bouton de retour par défaut
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement des éléments en début de colonne
        children: [
          Text(userData.id.toString()), // Affiche l'ID de l'utilisateur
          Text("Nom: " + userData.nom.toString()), // Affiche le nom de l'utilisateur
          Text("Prénom: " + userData.prenom.toString()), // Affiche le prénom de l'utilisateur
          Text("Email: " + userData.email.toString()), // Affiche l'email de l'utilisateur

          // Boutons "Inscription" et "Connexion" visibles uniquement si l'utilisateur est non connecté (id=0)
          if (userData.id.toString() == "0")
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Inscription"), // Bouton pour s'inscrire
            ),
          if (userData.id.toString() == "0")
            ElevatedButton(
              onPressed: connexion,
              child: const Text("Connexion"), // Bouton pour se connecter
            ),

          // Boutons accessibles à tous les utilisateurs
          ElevatedButton(
            onPressed: profile,
            child: const Text("Profile"), // Accède au profil de l'utilisateur
          ),
          ElevatedButton(
            onPressed: evaluations,
            child: const Text("Evaluations"), // Accède aux évaluations
          ),
          ElevatedButton(
            onPressed: resultats,
            child: const Text("Résultats"), // Accède aux résultats
          ),
          
          // Bouton "Panel Admin" visible uniquement si l'utilisateur est admin (role=true)
          if (userData.role == true)
            ElevatedButton(
              onPressed: admin,
              child: const Text("Panel Admin"), // Accès au panneau admin pour les administrateurs
            ),
        ],
      ),
    );
  }
}
