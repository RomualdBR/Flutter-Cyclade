import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cyclade/constant.dart';
import 'package:flutter_cyclade/models/questionModel.dart';
import 'package:flutter_cyclade/models/resultatTestModel.dart';
import 'package:flutter_cyclade/services/questionService.dart';
import 'package:flutter_cyclade/services/resultService.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PassTestPage extends StatefulWidget {
  final String testId;
  
  const PassTestPage({Key? key, required this.testId}) : super(key: key);

  @override
  State<PassTestPage> createState() => _PassTestPageState();
}

class _PassTestPageState extends State<PassTestPage> {
  String titleTest = "NomTest";
  int currentIndex = 0; // Index pour suivre la question actuelle
  List<Question> questions = []; // Liste pour stocker les questions
  late Question currentQuestion; // Question actuelle
  late Timer _timer; // Minuteur
  int _timeRemaining = 0; // Temps restant pour la question actuelle
  int score = 0; // Compteur de bonnes réponses
  int? _selectedAnswer; // Pour gérer la sélection de réponse

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    questions = await QuestionService.getQuestionsByTestId(widget.testId);
    if (questions.isNotEmpty) {
      setState(() {
        currentQuestion = questions[currentIndex];
        _timeRemaining = currentQuestion.seconds; // Initialise le timer avec le temps de la première question
      });
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer.cancel();
        nextQuestion(isTimeUp: true); // Passe à la question suivante lorsque le temps est écoulé
      }
    });
  }

  void nextQuestion({bool isTimeUp = false}) {
    if (_timer.isActive) _timer.cancel(); // Arrête le timer de la question actuelle

    // Vérifie la bonne réponse si l'utilisateur a répondu dans le temps imparti
    if (!isTimeUp && _selectedAnswer == currentQuestion.reponse) {
      score++; // Incrémente le score pour une bonne réponse
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        currentQuestion = questions[currentIndex];
        _timeRemaining = currentQuestion.seconds; // Redémarre le temps pour la nouvelle question
        _selectedAnswer = null; // Réinitialise la sélection de réponse
      });
      startTimer(); // Redémarre le timer pour la nouvelle question
    } else {
      _completeTest(); // Envoie le résultat si le test est terminé
    }
  }

  Future<void> _completeTest() async {
    // Fonction d'envoi du score en BDD
    DateTime date = DateTime.now();
    String id_user = userData.id;
    String id_test = widget.testId;

    var newResult = ResultatTest(
      id: mongo.ObjectId().toHexString(),
      id_test: id_test,
      id_user: id_user,
      date: date,
      score: score,
    );

    await ResultService.createResult(newResult);

    // Affiche un message de confirmation et retourne à la page précédente
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Test terminé"),
        content: Text("Votre score : $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme le dialogue
              Navigator.pop(context); // Retourne à la page précédente
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Annule le timer lors de la fermeture de la page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$titleTest - Q${currentIndex + 1}"),
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loader en attendant les questions
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(currentQuestion.intitule, style: TextStyle(fontSize: 18)), // Affiche l'intitulé de la question
                ),
                Text("Temps restant : $_timeRemaining s", style: TextStyle(fontSize: 16)), // Affiche le temps restant
                Column(
                  children: [
                    // Proposition 1
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: _selectedAnswer,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedAnswer = value;
                            });
                          },
                        ),
                        Text(currentQuestion.proposition_1),
                      ],
                    ),
                    // Proposition 2
                    Row(
                      children: [
                        Radio<int>(
                          value: 2,
                          groupValue: _selectedAnswer,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedAnswer = value;
                            });
                          },
                        ),
                        Text(currentQuestion.proposition_2),
                      ],
                    ),
                    // Proposition 3
                    Row(
                      children: [
                        Radio<int>(
                          value: 3,
                          groupValue: _selectedAnswer,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedAnswer = value;
                            });
                          },
                        ),
                        Text(currentQuestion.proposition_3),
                      ],
                    ),
                    // Proposition 4
                    Row(
                      children: [
                        Radio<int>(
                          value: 4,
                          groupValue: _selectedAnswer,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedAnswer = value;
                            });
                          },
                        ),
                        Text(currentQuestion.proposition_4),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    nextQuestion(); // Passe à la question suivante
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
    );
  }
}
