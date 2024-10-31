import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/services/questionService.dart';

// Page pour modifier une question existante
class EditQuestionPage extends StatefulWidget {
  final Question question; // Question existante à éditer

  const EditQuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  // Contrôleurs de texte pour chaque champ de la question
  late TextEditingController _questionTextController;
  late TextEditingController _prop1Controller;
  late TextEditingController _prop2Controller;
  late TextEditingController _prop3Controller;
  late TextEditingController _prop4Controller;
  late TextEditingController _secondsController;
  late List<bool> _reponseController;

  @override
  void initState() {
    super.initState();
    // Initialise les champs avec les valeurs actuelles de la question
    _questionTextController = TextEditingController(text: widget.question.intitule);
    _prop1Controller = TextEditingController(text: widget.question.proposition_1);
    _prop2Controller = TextEditingController(text: widget.question.proposition_2);
    _prop3Controller = TextEditingController(text: widget.question.proposition_3);
    _prop4Controller = TextEditingController(text: widget.question.proposition_4);
    _secondsController = TextEditingController(text: widget.question.seconds.toString());
    _reponseController = List<bool>.from(widget.question.reponse);
  }

  // Fonction pour mettre à jour la question
  Future<void> _updateQuestion() async {
    final updatedQuestion = Question(
      id: widget.question.id,
      id_test: widget.question.id_test,
      intitule: _questionTextController.text.trim(),
      proposition_1: _prop1Controller.text.trim(),
      proposition_2: _prop2Controller.text.trim(),
      proposition_3: _prop3Controller.text.trim(),
      proposition_4: _prop4Controller.text.trim(),
      reponse: _reponseController, // Réponses sélectionnées
      seconds: int.parse(_secondsController.text.trim()), // Durée de la question
    );

    // Appel au service pour mettre à jour la question en base de données
    final result = await QuestionService.updateQuestion(updatedQuestion);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    Navigator.pop(context, updatedQuestion); // Retourne la question mise à jour à la page précédente
  }

  // Construction de l'interface utilisateur pour modifier la question
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier la Question")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de saisie pour l'intitulé de la question
            TextField(
              controller: _questionTextController,
              decoration: const InputDecoration(labelText: "Intitulé de la question"),
            ),
            // Champs de saisie pour chaque proposition de réponse
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
            // Champ pour saisir la durée de la question (en secondes)
            TextField(
              controller: _secondsController,
              decoration: const InputDecoration(labelText: "Durée en secondes"),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Limite aux chiffres
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20), // Espace avant le bouton de mise à jour
            // Bouton pour enregistrer les modifications
            ElevatedButton(
              onPressed: _updateQuestion,
              child: const Text("Enregistrer les modifications"),
            ),
          ],
        ),
      ),
    );
  }
}
