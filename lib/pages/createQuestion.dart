import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _secondsController = TextEditingController();

  // Liste de booléens pour garder les états des CheckBox de chaque réponse
  List<bool> _reponseController = [false, false, false, false];

  // Fonction pour créer une question
  Future<void> _createQuestion() async {
    String questionText = _questionTextController.text.trim();
    String prop1 = _prop1Controller.text.trim();
    String prop2 = _prop2Controller.text.trim();
    String prop3 = _prop3Controller.text.trim();
    String prop4 = _prop4Controller.text.trim();
    List<bool> reponse = _reponseController;
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
      id: ObjectId().toHexString(),
      id_test: widget.testId,
      intitule: questionText,
      proposition_1: prop1,
      proposition_2: prop2,
      proposition_3: prop3,
      proposition_4: prop4,
      reponse: reponse,
      seconds: seconds,
    );

    // Envoie la question au service de création et affiche le résultat
    String result = await QuestionService.createQuestion(newQuestion);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    Navigator.pop(context, newQuestion);
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
            TextField(
              controller: _questionTextController,
              decoration: const InputDecoration(labelText: "Intitulé de la question"),
            ),
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
            const SizedBox(height: 20),
            const Text("Sélectionnez les bonnes réponses :"),
            // Choix des réponses pour le qcm
            CheckboxListTile(
              title: const Text("Proposition 1"),
              value: _reponseController[0],
              onChanged: (bool? value) {
                setState(() {
                  _reponseController[0] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Proposition 2"),
              value: _reponseController[1],
              onChanged: (bool? value) {
                setState(() {
                  _reponseController[1] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Proposition 3"),
              value: _reponseController[2],
              onChanged: (bool? value) {
                setState(() {
                  _reponseController[2] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Proposition 4"),
              value: _reponseController[3],
              onChanged: (bool? value) {
                setState(() {
                  _reponseController[3] = value ?? false;
                });
              },
            ),
            TextField(
              controller: _secondsController,
              decoration: const InputDecoration(labelText: "Durée en secondes"),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Limite aux chiffres
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createQuestion,
              child: const Text("Créer la question"),
            ),
          ],
        ),
      ),
    );
  }
}
