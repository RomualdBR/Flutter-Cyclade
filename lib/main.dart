import 'package:flutter/material.dart';
import 'package:flutter_cyclade/pages/accueil.dart';
import 'package:flutter_cyclade/pages/inscription.dart';
import 'package:flutter_cyclade/pages/connexion.dart';
import 'package:flutter_cyclade/pages/passTest.dart';
import 'package:flutter_cyclade/pages/profile.dart';
import 'package:flutter_cyclade/pages/evaluations.dart';
import 'package:flutter_cyclade/pages/graph.dart';
import 'package:flutter_cyclade/pages/resultats.dart';
import 'package:flutter_cyclade/pages/admin.dart';
import 'package:flutter_cyclade/pages/createTest.dart';
import 'package:flutter_cyclade/pages/createQuestion.dart';
import 'package:flutter_cyclade/pages/editQuestion.dart';
import 'package:flutter_cyclade/pages/editTest.dart';





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
        '/connexion': (context) => const ConnexionPage(),
        '/profile': (context) => const ProfilePage(),
        '/evaluations': (context) => const EvaluationsPage(),
        '/graphiques': (context) => GraphPage(),
        '/resultats': (context) => const ResultatsPage(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}
