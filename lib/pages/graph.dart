import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Bibliothèque pour les graphiques
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/services/questionService.dart';
import 'package:flutter_cyclade/services/testService.dart';
import 'package:flutter_cyclade/services/resultService.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  Map<String, double> scoresParDate = {}; // Stockage des scores par date
  double tauxReussiteGeneral = 0.0; // Taux de réussite global

  List<Test> _tests = []; // Liste des tests chargés
  Map<String, List<ResultatTest>> _testResults = {}; // Résultats par test

  @override
  void initState() {
    super.initState();
    fetchData(); // Récupération des données de scores et taux de réussite
    _loadResultsByTests(); // Chargement des résultats par test
  }

  Future<void> _loadResultsByTests() async {
    _tests = await TestService.getAllTests(); // Récupérer tous les tests
    for (var test in _tests) {
      // Récupération des scores pour chaque test
      _testResults[test.id] = await MongoDatabase.getAllScoresByTest(test.id);
    }
    setState(() {}); // Actualisation de l'état
    print(_testResults);
  }

  void fetchData() async {
    scoresParDate = await MongoDatabase().calculerScoresParDate(); // Scores organisés par date
    tauxReussiteGeneral = await MongoDatabase().calculerTauxReussiteGeneral(); // Calcul taux de réussite général
    print("Scores par date: $scoresParDate"); 
    print("Taux de réussite général: $tauxReussiteGeneral"); 
    setState(() {});
  }

  // Construction de la page graphique
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taux de Réussite', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: PageView(
          children: [
            ChartCard(
              title: 'Taux de Réussite par Discipline',
              child: BarChartWidget(), // Affiche le diagramme en barres
            ),
            ChartCard(
              title: 'Taux de Réussite Général',
              child: LineChartWidget(scoresParDate: scoresParDate), // Affiche le graphique en ligne
            ),
          ],
        ),
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Conteneur animé avec effets d'ombre et bordure
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(134, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 108, 108, 108).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(child: child), // Affichage du graphique
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: [
          // Groupes de barres pour chaque matière avec différentes couleurs
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 30, color: Colors.red)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 90, color: Colors.green)]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 60),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  // Affichage des labels sous chaque barre
                  case 0: return Text('Java', style: TextStyle(color: Colors.white));
                  case 1: return Text('Algo', style: TextStyle(color: Colors.white));
                  case 2: return Text('HTML/CSS', style: TextStyle(color: Colors.white));
                  default: return Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false), // Masque les grilles pour simplifier l'affichage
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final Map<String, double> scoresParDate;  
  
  LineChartWidget({required this.scoresParDate});
  
  @override
  Widget build(BuildContext context) {
    final sortedEntries = scoresParDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Tri des scores par date

    final spots = sortedEntries.asMap().entries.map((entry) {
      // Convertit les entrées triées en points de graphique
      final index = entry.key.toDouble(); 
      final score = entry.value.value;   
      return FlSpot(index, score);
    }).toList();

    final labels = sortedEntries.map((entry) => entry.key).toList(); // Labels de l'axe X

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true, // Ligne courbée pour une meilleure lisibilité
            color: Colors.blue,
            dotData: FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < labels.length) {
                  return Text(
                    labels[index], 
                    style: TextStyle(color: Colors.white),
                  );
                }
                return Text('');
              },
              interval: 1, 
            ),
          ),
          leftTitles: AxisTitles( // Désactive les titres de l'axe Y
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles( // Désactive les titres en haut
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true), // Active la grille pour les lignes de référence
      ),
    );
  }
}
