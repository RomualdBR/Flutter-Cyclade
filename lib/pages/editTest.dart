import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:flutter_cyclade/services/databaseService.dart';

class EditTestPage extends StatefulWidget {
  final Test test;

  const EditTestPage({Key? key, required this.test}) : super(key: key);

  @override
  State<EditTestPage> createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  late TextEditingController _testNameController;

  @override
  void initState() {
    super.initState();
    _testNameController = TextEditingController(text: widget.test.nom_discipline);
  }

  Future<void> _updateTest() async {
    final updatedTest = Test(
      id: widget.test.id,
      nom_discipline: _testNameController.text.trim(),
    );

    final result = await MongoDatabase.updateTest(updatedTest);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    Navigator.pop(context, updatedTest); // Retourne le test mis à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le Test")),
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
              onPressed: _updateTest,
              child: const Text("Enregistrer les modifications"),
            ),
          ],
        ),
      ),
    );
  }
}
