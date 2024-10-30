import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/userProvider.dart';
import 'package:provider/provider.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AccueilPage> {
  void onPressed() {
    Navigator.pushNamed(context, '/inscription');
  }

  void connexion() {
    Navigator.pushNamed(context, '/connexion');
  }

  void profile() {
    Navigator.pushNamed(context, '/profile');
  }

  void evaluations() {
    Navigator.pushNamed(context, '/evaluations');
  }

  void resultats() {
    Navigator.pushNamed(context, '/resultats');
  }

  void graphiques() {
    Navigator.pushNamed(context, '/graphiques');
  }

  void admin() {
    Navigator.pushNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userProvider.user.id.toString()),
          Text("Nom: " + userProvider.user.nom.toString()),
          Text("Prénom: " + userProvider.user.prenom.toString()),
          Text("Email: " + userProvider.user.email.toString()),
          if (userProvider.user.id.toString() == "0")
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Inscription"),
            ),
          if (userProvider.user.id.toString() == "0")
            ElevatedButton(
              onPressed: connexion,
              child: const Text("Connexion"),
            ),
          ElevatedButton(
            onPressed: profile,
            child: const Text("Profile"),
          ),
          ElevatedButton(
            onPressed: evaluations,
            child: const Text("Evaluations"),
          ),
          ElevatedButton(
            onPressed: resultats,
            child: const Text("Résultats"),
          ),
          

          // Bouton "Panel Admin" visible uniquement si l'utilisateur est admin
          if (userProvider.user.role == true)
            ElevatedButton(
              onPressed: admin,
              child: const Text("Panel Admin"),
            ),
        ],
      ),
    );
  }
}
