import 'package:flutter/material.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/models/testModel.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import './editQuestion.dart';
import './editTest.dart';
import './createTest.dart';
import './createQuestion.dart';
import 'package:flutter_cyclade/services/questionService.dart';
import 'package:flutter_cyclade/services/testService.dart';
import 'package:flutter_cyclade/services/resultService.dart';

// Classe de la page d'administration avec les fonctionnalités de gestion des tests et questions
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Liste de tests
  List<Test> _tests = [];
  // Map associant les questions à chaque test
  Map<String, List<Question>> _testQuestions = {};
  final TextEditingController _testNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTestsAndQuestions(); // Charge les tests et questions au démarrage
  }

  // Charge les tests et les questions associées
  Future<void> _loadTestsAndQuestions() async {
    _tests = await TestService.getAllTests();
    for (var test in _tests) {
      _testQuestions[test.id] = await QuestionService.getQuestionsByTestId(test.id);
    }
    setState(() {}); // Met à jour l'interface avec les nouvelles données
  }

  // Création d'un nouveau test
  Future<void> _createTest() async {
    String testName = _testNameController.text.trim();
    if (testName.isEmpty) return;

    var newTest = Test(id: ObjectId().toHexString(), nom_discipline: testName);
    String result = await TestService.createTest(newTest);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    _testNameController.clear();
    _loadTestsAndQuestions();
  }

  // Suppression d'un test
  Future<void> _deleteTest(String testId) async {
    final result = await TestService.deleteTest(testId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    _loadTestsAndQuestions();
  }

  // Navigation vers la page d'édition du test
  Future<void> _editTest(Test test) async {
    final updatedTest = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTestPage(test: test)),
    );
    if (updatedTest != null) {
      setState(() {
        _tests = _tests.map<Test>((t) => t.id == test.id ? updatedTest : t).toList();
      });
    }
  }

  // Crée et ajoute un nouveau test
  Future<void> _navigateToCreateTest() async {
    final newTest = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTestPage()),
    );

    if (newTest != null) {
      setState(() {
        _tests.add(newTest);
      });
    }
  }

  // Suppression d'une question
  Future<void> _deleteQuestion(String questionId, String testId) async {
    final result = await QuestionService.deleteQuestion(questionId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    _loadTestsAndQuestions();
  }

  // Édition d'une question
  Future<void> _editQuestion(Question question) async {
    final updatedQuestion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditQuestionPage(question: question)),
    );
    if (updatedQuestion != null) {
      setState(() {
        _testQuestions[question.id_test] = _testQuestions[question.id_test]!
            .map<Question>((q) => q.id == question.id ? updatedQuestion : q)
            .toList();
      });
    }
  }

  // Ajout d'une question à un test
  Future<void> _addQuestion(String testId) async {
    final newQuestion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateQuestionPage(testId: testId)),
    );

    if (newQuestion != null) {
      setState(() {
        _testQuestions[testId] = [...?_testQuestions[testId], newQuestion];
      });
    }
  }

  // Navigation vers la page de graphiques
  void graphiques() {
    Navigator.pushNamed(context, '/graphiques');
  }

  // Création d'un résultat générique
  Future<void> _createResult() async {
    int score = 18;
    DateTime date = DateTime(2018, 1, 14);
    String id_user = "672100005b607787f5000000";
    String id_test = "672134f722eed9ed84000000";

    var newResult = ResultatTest(
      id: ObjectId().toHexString(),
      id_test: id_test,
      id_user: id_user,
      date: date,
      score: score,
    );

    String result = await ResultService.createResult(newResult);
  }

  // Affichage de la page d'administration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Admin")),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ElevatedButton(
            onPressed: graphiques,
            child: const Text("Graphique : taux de réussite global"),
          ),
          ElevatedButton(
            onPressed: _navigateToCreateTest,
            child: const Text("Créer un Test"),
          ),
          ElevatedButton(
            onPressed: _createResult,
            child: const Text("Créer un Résultat générique"),
          ),
          const SizedBox(height: 20),
          // Affiche la liste des tests avec options d'édition et de suppression
          ..._tests.map((test) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            test.nom_discipline,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editTest(test),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTest(test.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: () => _addQuestion(test.id),
                        child: const Text("Ajouter une question"),
                      ),
                      // Affiche les questions du test
                      ...(_testQuestions[test.id] ?? []).map((question) => Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(question.intitule),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("1: ${question.proposition_1}"),
                                  Text("2: ${question.proposition_2}"),
                                  Text("3: ${question.proposition_3}"),
                                  Text("4: ${question.proposition_4}"),
                                  Text("Réponse: ${question.reponse}"),
                                  Text("Durée: ${question.seconds}s"),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editQuestion(question),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteQuestion(question.id, test.id),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
