import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  Map<String, double> scoresParDate = {};
  double tauxReussiteGeneral = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
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
              child: BarChartWidget(),
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
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: [
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
    final spots = scoresParDate.entries
    .toList()
    .asMap()
    .entries
    .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value)) 
    .toList();


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
        
      ),
    );
  }
}

  
