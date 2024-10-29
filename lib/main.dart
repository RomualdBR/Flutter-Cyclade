import 'package:flutter/material.dart';
import 'package:flutter_cyclade/pages/accueil.dart';
import 'package:flutter_cyclade/pages/inscription.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annuaire Téléphonique',
      initialRoute: '/',
      routes: {
        '/': (context) => const AccueilPage(),
        '/inscription': (context) => const InscriptionPage(),
      },
    );
  }
}
