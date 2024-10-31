import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:flutter_cyclade/services/testService.dart';

// Page pour éditer les informations d'un test existant
class EditTestPage extends StatefulWidget {
  final Test test;

  const EditTestPage({Key? key, required this.test}) : super(key: key);

  @override
  State<EditTestPage> createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  // Contrôleur pour capturer et modifier le nom du test
  late TextEditingController _testNameController;

  @override
  void initState() {
    super.initState();
    // Initialise le champ de texte avec le nom actuel du test
    _testNameController = TextEditingController(text: widget.test.nom_discipline);
  }

  // Fonction pour mettre à jour le test
  Future<void> _updateTest() async {
    final updatedTest = Test(
      id: widget.test.id, // Conserve l'ID actuel du test
      nom_discipline: _testNameController.text.trim(), // Nouveau nom pour le test
    );

    // Envoie les modifications au service de mise à jour
    final result = await TestService.updateTest(updatedTest);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    Navigator.pop(context, updatedTest); // Retourne le test mis à jour à la page précédente
  }

  // Construction de l'interface utilisateur pour modifier le test
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Marge autour du contenu
        child: Column(
          children: [
            // Champ de saisie pour le nom de la discipline
            TextField(
              controller: _testNameController,
              decoration: const InputDecoration(labelText: "Nom de la discipline"),
            ),
            const SizedBox(height: 20), // Espacement avant le bouton de mise à jour

            // Bouton pour enregistrer les modifications
            ElevatedButton(
              onPressed: _updateTest, // Appelle _updateTest lors de la soumission
              child: const Text("Enregistrer les modifications"),
            ),
          ],
        ),
      ),
    );
  }
}
