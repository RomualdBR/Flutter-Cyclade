import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

class ResultatsPage extends StatefulWidget {
  const ResultatsPage({super.key});

  @override
  State<ResultatsPage> createState() => _ResultatsPageState();
}

class _ResultatsPageState extends State<ResultatsPage> {
  List<Map<String, dynamic>> passedTests = [];
  List<Map<String, dynamic>> filteredTests = [];

  String searchQuery = '';
  String selectedYear = 'Toutes les années';

  @override
  void initState() {
    super.initState();
    _loadPassedTests();
  }

  // Initialement, tous les tests sont affichés
  Future<void> _loadPassedTests() async {
    var tests = await MongoDatabase.getPassedTests();
    setState(() {
      passedTests = tests;
      filteredTests = tests; 
    });
  }

  // Utilitaire pour formater la date en 'année-mois-jour'
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Filtrer les résultats par nom et année
  void _filterTests() {
    setState(() {
      filteredTests = passedTests.where((test) {
        final matchesName = searchQuery.isEmpty ||
            test['user_name'].toLowerCase().contains(searchQuery.toLowerCase());
        final matchesYear = selectedYear == 'Toutes les années' ||
            formatDate(test['date']).startsWith(selectedYear);
        return matchesName && matchesYear;
      }).toList();
    });
  }

  // Contenu de la page
  @override
  Widget build(BuildContext context) {
    // Extraire les années uniques des tests pour le sélecteur
    List<String> years = passedTests
        .map((test) => formatDate(test['date']).substring(0, 4)) // Extraire l'année
        .toSet()
        .toList();
    years.sort(); // Trier les années
    years.insert(0, 'Toutes les années'); // Option pour voir toutes les années

    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultats"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Champ de recherche
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Rechercher par prénom ou nom',
                      prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                      _filterTests(); // Appliquer le filtre dès que le texte change
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Sélecteur d'année
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.deepPurple, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedYear,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                      items: years.map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year, style: const TextStyle(color: Colors.deepPurple)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                          _filterTests(); // Appliquer le filtre lors du changement d'année
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredTests.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredTests.length,
                    itemBuilder: (context, index) {
                      var test = filteredTests[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.deepPurple),
                                  const SizedBox(width: 8),
                                  Text(
                                    test['user_name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.assignment, color: Colors.blueGrey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Test: ${test['test_name']}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Colors.teal),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Date: ${formatDate(test['date'])}",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Score: ${test['score']}/${test['question_count']}", // Modifié pour afficher le score basé sur le nombre de questions
                                        style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
