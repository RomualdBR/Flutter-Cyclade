import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:flutter_cyclade/services/testService.dart';

// Page pour créer un nouveau test
class CreateTestPage extends StatefulWidget {
  const CreateTestPage({Key? key}) : super(key: key);

  @override
  State<CreateTestPage> createState() => _CreateTestPageState();
}

class _CreateTestPageState extends State<CreateTestPage> {
  // Contrôleur pour capturer le nom du test entré par l'utilisateur
  final TextEditingController _testNameController = TextEditingController();

  // Fonction pour créer un nouveau test
  Future<void> _createTest() async {
    String testName = _testNameController.text.trim();

    // Vérifie que le champ de nom de test n'est pas vide
    if (testName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le nom de la discipline est requis.")),
      );
      return;
    }

    // Crée une instance de Test avec un ID unique
    var newTest = Test(
      id: ObjectId().toHexString(), // Génère un nouvel ObjectId pour le test
      nom_discipline: testName,
    );

    // Envoie la requête de création de test et affiche le résultat
    String result = await TestService.createTest(newTest);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    Navigator.pop(context, newTest); // Ferme la page et renvoie le test créé
  }

  // Construction de l'interface utilisateur pour la création de test
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Marge autour du contenu
        child: Column(
          children: [
            // Champ de saisie pour le nom de la discipline
            TextField(
              controller: _testNameController,
              decoration: const InputDecoration(labelText: "Nom de la discipline"),
            ),
            const SizedBox(height: 20), // Espace avant le bouton de création

            // Bouton pour déclencher la création du test
            ElevatedButton(
              onPressed: _createTest, // Appelle _createTest lors de la soumission
              child: const Text("Créer le Test"),
            ),
          ],
        ),
      ),
    );
  }
}
