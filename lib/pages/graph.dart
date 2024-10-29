// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart'; 
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatelessWidget {
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
        child: Column(
          children: [
            Text(
              'Taux de Réussite par Discipline',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(child: BarChartWidget()),
            SizedBox(height: 10),
            Text(
              'Taux de Réussite Général',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(child: LineChartWidget()),
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
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 40, color: Colors.blue)]),//a modifier mettre 
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 30, color: Colors.red)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 90, color: Colors.green)]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
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
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0: return Text('2010', style: TextStyle(color: Colors.white));
                  case 1: return Text('2012', style: TextStyle(color: Colors.white));
                  case 2: return Text('2013', style: TextStyle(color: Colors.white));
                  case 3: return Text('2014', style: TextStyle(color: Colors.white));
                  case 4: return Text('2015', style: TextStyle(color: Colors.white));
                  default: return Text('');
                }
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 30),
              FlSpot(1, 50),
              FlSpot(2, 70),
              FlSpot(3, 60),
              FlSpot(4, 90),
            ],
            isCurved: true,
            color: Colors.blue, // Couleur de la ligne
            // belowBarData: BarAreaData(show: true, colors: [Colors.blue.withOpacity(0.3)]),
          ),
        ],
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)), // Bordure blanche
      ),
    );
  }
}
