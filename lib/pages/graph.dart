// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  Map<String, double> scoresParDate = {};
  double tauxReussiteGeneral = 0.0;
  List<Test> _tests = [];
  Map<String, List<ResultatTest>> _testResults = {};

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadResultsByTests();
  }

  Future<void> _loadResultsByTests() async {
    _tests = await TestService.getAllTests();
    for (var test in _tests) {
      _testResults[test.nom_discipline] = await MongoDatabase.getAllScoresByTest(test.id);
    }
    setState(() {}); 
    print(_testResults);
    
  }

  void fetchData() async {
    scoresParDate = await MongoDatabase().calculerScoresParDate();
    tauxReussiteGeneral = await MongoDatabase().calculerTauxReussiteGeneral();
    print("Scores par date: $scoresParDate");
    print("Taux de réussite général: $tauxReussiteGeneral");

    setState(() {});
  }

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
              child: BarChartWidget(testResults: _testResults),
            ),
            ChartCard(
              title: 'Taux de Réussite Général',
              child: LineChartWidget(scoresParDate: scoresParDate),
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
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  void _onHover(BuildContext context, bool isHovering) {
   
  }
}

class BarChartWidget extends StatelessWidget {
  final Map<String, List<ResultatTest>> testResults;

  BarChartWidget({required this.testResults});

  @override
  Widget build(BuildContext context) {
    final disciplines = testResults.keys.toList();

    final barGroups = disciplines.asMap().entries.map((entry) {
      int index = entry.key;
      String discipline = entry.value;

      // Calcul du pourcentage de réussite pour chaque discipline
      int totalNotes = testResults[discipline]!.length;
      int notesSup10 = testResults[discipline]!
          .where((resultat) => resultat.score > 10)
          .length;
      double pourcentageReussite = (notesSup10 / totalNotes) * 100;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: pourcentageReussite, // Affichage du pourcentage de réussite
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                
                  return Text(
                    disciplines[index],
                    style: TextStyle(color: Colors.white),
                  );
                
                return Text('');
              },
              
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        
        
      ),
    );
  }
}


  
class LineChartWidget extends StatelessWidget {
  final Map<String, double> scoresParDate;  
  
  LineChartWidget({required this.scoresParDate});
  
  @override
  Widget build(BuildContext context) {
    // Trier les scores par date en ordre croissant
    final sortedEntries = scoresParDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    
    final spots = sortedEntries.asMap().entries.map((entry) {
      final index = entry.key.toDouble(); 
      final score = entry.value.value;   
      return FlSpot(index, score);
    }).toList();

    
    final labels = sortedEntries.map((entry) => entry.key).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
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
          leftTitles: AxisTitles( // Désactiver les titres de l'axe Y
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles( // Désactiver les titres en haut du graphique
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
  }
}
