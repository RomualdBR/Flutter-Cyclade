import 'package:flutter/material.dart';
import 'package:flutter_cyclade/services/databaseService.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:flutter_cyclade/services/questionService.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

class EditQuestionPage extends StatefulWidget {
  final Question question;

  const EditQuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late TextEditingController _questionTextController;
  late TextEditingController _prop1Controller;
  late TextEditingController _prop2Controller;
  late TextEditingController _prop3Controller;
  late TextEditingController _prop4Controller;
  late TextEditingController _correctAnswerController;

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.question.intitule);
    _prop1Controller = TextEditingController(text: widget.question.proposition_1);
    _prop2Controller = TextEditingController(text: widget.question.proposition_2);
    _prop3Controller = TextEditingController(text: widget.question.proposition_3);
    _prop4Controller = TextEditingController(text: widget.question.proposition_4);
    _correctAnswerController = TextEditingController(text: widget.question.reponse.toString());
  }

  Future<void> _updateQuestion() async {
    final updatedQuestion = Question(
      id: widget.question.id,
      id_test: widget.question.id_test,
      intitule: _questionTextController.text.trim(),
      proposition_1: _prop1Controller.text.trim(),
      proposition_2: _prop2Controller.text.trim(),
      proposition_3: _prop3Controller.text.trim(),
      proposition_4: _prop4Controller.text.trim(),
      reponse: int.parse(_correctAnswerController.text.trim()),
    );

    final result = await QuestionService.updateQuestion(updatedQuestion);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    Navigator.pop(context, updatedQuestion); // Retourne la question mise à jour à la page précédente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier la Question")),
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
            TextField(
              controller: _correctAnswerController,
              decoration: const InputDecoration(labelText: "Réponse correcte (1-4)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
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
