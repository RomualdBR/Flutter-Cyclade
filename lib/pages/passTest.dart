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
  int currentIndex = 0;
  List<Question> questions = [];
  late Question currentQuestion;
  late Timer _timer;
  int _timeRemaining = 0;
  int score = 0;
  List<bool> _selectedAnswers = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // Chargement des questions
  Future<void> loadQuestions() async {
    questions = await QuestionService.getQuestionsByTestId(widget.testId);
    if (questions.isNotEmpty) {
      setState(() {
        currentQuestion = questions[currentIndex];
        _timeRemaining = currentQuestion.seconds;
      });
      startTimer();
    }
  }

  // Début du timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer.cancel();
        nextQuestion(isTimeUp: true);
      }
    });
  }

  // Passer à la prochaine question 
  void nextQuestion({bool isTimeUp = false}) {
    if (_timer.isActive) _timer.cancel();

    // Compare la réponse de l'utilisateur avec la bonne réponse
    if (!isTimeUp && _selectedAnswers.toString() == currentQuestion.reponse.toString()) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        currentQuestion = questions[currentIndex];
        _timeRemaining = currentQuestion.seconds;
        _selectedAnswers = [false, false, false, false];
      });
      startTimer();
    } else {
      _completeTest();
    }
  }

  // Dire que le test est terminé et crée un résultat
  Future<void> _completeTest() async {
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Test terminé"),
        content: Text("Votre score : $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$titleTest - Q${currentIndex + 1}"),
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(currentQuestion.intitule, style: TextStyle(fontSize: 18)),
                ),
                Text("Temps restant : $_timeRemaining s", style: TextStyle(fontSize: 16)),
                Column(
                  children: [
                    CheckboxListTile(
                      title: Text(currentQuestion.proposition_1),
                      value: _selectedAnswers[0],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedAnswers[0] = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(currentQuestion.proposition_2),
                      value: _selectedAnswers[1],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedAnswers[1] = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(currentQuestion.proposition_3),
                      value: _selectedAnswers[2],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedAnswers[2] = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(currentQuestion.proposition_4),
                      value: _selectedAnswers[3],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedAnswers[3] = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    nextQuestion();
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
    );
  }
}
