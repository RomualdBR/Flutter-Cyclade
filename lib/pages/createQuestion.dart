import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/services/questionService.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

// Page de création de question, recevant l'ID du test auquel elle appartient
class CreateQuestionPage extends StatefulWidget {
  final String testId;

  const CreateQuestionPage({Key? key, required this.testId}) : super(key: key);

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  // Contrôleurs de texte pour chaque champ de saisie
  final TextEditingController _questionTextController = TextEditingController();
  final TextEditingController _prop1Controller = TextEditingController();
  final TextEditingController _prop2Controller = TextEditingController();
  final TextEditingController _prop3Controller = TextEditingController();
  final TextEditingController _prop4Controller = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  // Fonction pour créer une question
  Future<void> _createQuestion() async {
    String questionText = _questionTextController.text.trim();
    String prop1 = _prop1Controller.text.trim();
    String prop2 = _prop2Controller.text.trim();
    String prop3 = _prop3Controller.text.trim();
    String prop4 = _prop4Controller.text.trim();
    int correctAnswer = int.parse(_correctAnswerController.text.trim());
    int seconds = int.parse(_secondsController.text.trim());

    // Vérifie que tous les champs sont remplis
    if ([questionText, prop1, prop2, prop3, prop4].any((text) => text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs doivent être remplis.")),
      );
      return;
    }

    // Crée une nouvelle instance de Question avec les valeurs saisies
    var newQuestion = Question(
      id: ObjectId().toHexString(), // Génère un ID unique pour la question
      id_test: widget.testId, // Associe la question au test en utilisant l'ID du test
      intitule: questionText,
      proposition_1: prop1,
      proposition_2: prop2,
      proposition_3: prop3,
      proposition_4: prop4,
      reponse: correctAnswer,
      seconds: seconds,
    );

    // Envoie la question au service de création et affiche le résultat
    String result = await QuestionService.createQuestion(newQuestion);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    Navigator.pop(context, newQuestion); // Ferme la page et renvoie la nouvelle question
  }

  // Construction de l'interface utilisateur pour la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer une Question")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de saisie pour l'intitulé de la question
            TextField(
              controller: _questionTextController,
              decoration: const InputDecoration(labelText: "Intitulé de la question"),
            ),
            // Champ de saisie pour chaque proposition de réponse
            TextField(
              controller: _prop1Controller,
              decoration: const InputDecoration(labelText: "Proposition 1"),
            ),
            TextField(
              controller: _prop2Controller,
              decoration: const InputDecoration(labelText: "Proposition 2"),
            ),
            TextField(
              controller: _prop3Controller,
              decoration: const InputDecoration(labelText: "Proposition 3"),
            ),
            TextField(
              controller: _prop4Controller,
              decoration: const InputDecoration(labelText: "Proposition 4"),
            ),
            // Champ de saisie pour la réponse correcte (doit être entre 1 et 4)
            TextField(
              controller: _correctAnswerController,
              decoration: const InputDecoration(labelText: "Réponse correcte (1-4)"),
              keyboardType: TextInputType.number,
            ),
            // Champ de saisie pour la durée de la question
            TextField(
              controller: _secondsController,
              decoration: const InputDecoration(labelText: "Durée de la question"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20), // Espacement avant le bouton
            // Bouton pour soumettre la question
            ElevatedButton(
              onPressed: _createQuestion, // Appelle _createQuestion lors de la soumission
              child: const Text("Créer la question"),
            ),
          ],
        ),
      ),
    );
  }
}
