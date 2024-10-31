import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:flutter_cyclade/pages/passTest.dart';
import 'package:flutter_cyclade/services/testService.dart';
import 'package:flutter_cyclade/services/resultService.dart';

class EvaluationsPage extends StatefulWidget {
  const EvaluationsPage({super.key});

  @override
  State<EvaluationsPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EvaluationsPage> {
  List<Test> _tests = [];

  void onPressed(String id) async {
    final test = await countResults(id);

    if (test < 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassTestPage(testId: id),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Il est impossible de repasser le test plus d'une fois")));
    }
  }

  Future<int> countResults(String id) async {
    final test = await ResultService.getAllResultsByUserAndTest(userData.id, id);
    return test.length;
  }

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    _tests = await TestService.getAllTests();

    setState(() {});
  }

  // Contenu de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Evaluations"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ..._tests.map((test) => ElevatedButton(
              onPressed: () => onPressed(test.id),
              child: Text(test.nom_discipline),
            )),
      ]),
    );
  }
}
