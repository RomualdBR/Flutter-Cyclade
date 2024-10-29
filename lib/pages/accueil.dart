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
      body: Column(children: [
        Text(userData.id.toString()),
        Text("Nom: "+userData.nom.toString()),
        Text("Prénom: "+userData.prenom.toString()),
        Text("Email: "+userData.email.toString()),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Inscription"),
        )
      ]),
    );
  }
}
