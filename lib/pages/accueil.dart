import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/services/databaseService.dart';


class AccueilPage
    extends StatefulWidget {
  const AccueilPage(
      {super.key});



  @override
  State<AccueilPage> createState() =>
      _MyHomePageState();
}



class _MyHomePageState
    extends State<AccueilPage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context)
                .colorScheme
                .inversePrimary,
        title: const Text("Accueil"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(userData.id.toString()),
        Text("Nom: "+userData.nom.toString()),
        Text("Prénom: "+userData.prenom.toString()),
        Text("Email: "+userData.email.toString()),

        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Inscription"),
        ),
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
        ElevatedButton(
          onPressed: graphiques,
          child: const Text("Graphiques"),
        ),
      ]),
    );
  }
}
