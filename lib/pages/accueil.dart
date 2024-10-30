import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

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

  

  void graphiques() {
    Navigator.pushNamed(context, '/graphiques');
  }

  void admin() {
    Navigator.pushNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userData.id.toString()),
          Text("Nom: " + userData.nom.toString()),
          Text("Prénom: " + userData.prenom.toString()),
          Text("Email: " + userData.email.toString()),
          if (userData.id.toString() == "0")
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Inscription"),
            ),
          if (userData.id.toString() == "0")
            ElevatedButton(
              onPressed: connexion,
              child: const Text("Connexion"),
            ),
          if (userData.id.toString() != "0")
            ElevatedButton(
              onPressed: profile,
              child: const Text("Profile"),
            ),
          if (userData.id.toString() != "0")
            ElevatedButton(
              onPressed: evaluations,
              child: const Text("Evaluations"),
            ),
          
          

          // Bouton "Panel Admin" visible uniquement si l'utilisateur est admin
          if (userData.role == true)
            ElevatedButton(
              onPressed: admin,
              child: const Text("Panel Admin"),
            ),
        ],
      ),
    );
  }
}
