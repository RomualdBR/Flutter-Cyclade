import 'package:flutter/material.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:flutter_cyclade/services/testService.dart';

class CreateTestPage extends StatefulWidget {
  const CreateTestPage({Key? key}) : super(key: key);

  @override
  State<CreateTestPage> createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  final TextEditingController _testNameController = TextEditingController();

  Future<void> _createTest() async {
    String testName = _testNameController.text.trim();
    if (testName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le nom de la discipline est requis.")),
      );
      return;
    }

    var newTest = Test(
      id: ObjectId().toHexString(),
      nom_discipline: testName,
    );

    String result = await TestService.createTest(newTest);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    Navigator.pop(context, newTest); // Retourne le nouveau test créé à AdminPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _testNameController,
              decoration: const InputDecoration(labelText: "Nom de la discipline"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTest,
              child: const Text("Créer le Test"),
            ),
          ],
        ),
      ),
    );
  }
}
